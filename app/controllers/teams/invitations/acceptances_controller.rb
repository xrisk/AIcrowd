# frozen_string_literal: true
class Teams::Invitations::AcceptancesController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_invitation
  before_action :set_team
  before_action :redirect_on_disallowed

  def index
    @challenge = @team.challenge
  end

  def create
    accept_atomically!
    notify_concerned_parties_later
    flash[:success] = 'You successfully joined the team!'
    redirect_to @team
  end

  private def set_invitation
    @invitation = TeamInvitation.find_by!(uuid: params[:team_invitation_uuid])
  end

  private def set_team
    @team = @invitation.team
  end

  private def redirect_on_disallowed
    if @invitation.invitee != current_participant
      flash[:error] = 'You may not accept an invitation on someone else’s behalf'
      redirect_to root_path
    elsif @team.team_participants.exists?(participant_id: current_participant.id)
      flash[:error] = 'You are already a member of this team'
      redirect_to @team
    elsif @invitation.status != :pending
      flash[:error] = 'This invitation is no longer valid'
      redirect_to @team
    elsif @team.challenge.teams_frozen?
      flash[:error] = 'The challenge has team-freeze in effect'
      redirect_to @team.challenge
    elsif current_participant.concrete_teams.where.not(id: @team.id).exists?(challenge_id: @team.challenge_id)
      flash[:error] = 'You are already a member of a different team for this challenge'
      redirect_to @team.challenge
    end
  end

  private def accept_atomically!
    @mails = {
      accepted_invitations: [],
      declined_invitations: [],
      canceled_invitations: [],
    }
    ActiveRecord::Base.transaction do
      # accept/reject pending invitations where participant is invited for this challenge
      TeamInvitation\
        .joins(:team)
        .where(status: :pending)
        .where(invitee_id: current_participant.id)
        .where(teams: { challenge_id: @team.challenge_id })
        .each do |inv|
          if (inv.id == @invitation.id)
            inv.update!(status: :accepted)
            @mails[:accepted_invitations] << inv.id
          else
            inv.update!(status: :declined)
            @mails[:declined_invitations] << inv.id
          end
        end
      # destroy personal team of this challenge
      Team\
        .joins(:team_participants)
        .includes(:team_invitations_pending)
        .where(challenge_id: @team.challenge_id)
        .where(team_participants: { participant_id: current_participant.id, role: :organizer })
        .each do |personal_team|
          personal_team.team_invitations_pending.each do |inv|
            @mails[:canceled_invitations] << {
              invitee_id: inv.invitee_id,
              team_name: personal_team.name,
            }
          end
          personal_team.destroy!
        end
      # check for team becoming concrete and auto-decline pending invitations to creator
      if @team.team_participants.count == 1
        creator = @team.team_participants.first.participant
        TeamInvitation\
          .joins(:team)
          .where(status: :pending)
          .where(invitee_id: creator.id)
          .where(teams: { challenge_id: @team.challenge_id })
          .each do |inv|
            inv.update!(status: :declined)
            @mails[:declined_invitations] << inv.id
          end
      end
      # become a member of the team
      @team.team_participants.create!(participant_id: current_participant.id)
    end
  end

  private def notify_concerned_parties_later
    Team::InvitationAcceptedNotifierJob.perform_later(current_participant.id, @mails)
  end
end
