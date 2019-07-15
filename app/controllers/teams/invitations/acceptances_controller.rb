class Teams::Invitations::AcceptancesController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_team
  before_action :set_invitation

  def create
    if @invitation.invitee != current_participant
      flash[:error] = 'You may not accept an invitation on someone else’s behalf'
      redirect_to @team.challenge
    elsif @team.team_participants.exists?(participant_id: current_participant.id)
      flash[:error] = 'You are already a member of this team'
      redirect_to @team
    elsif @team.challenge.teams_frozen?
      flash[:error] = 'The challenge has team-freeze in effect'
      redirect_to @team.challenge
    elsif current_participant.concrete_teams.where.not(id: @team.id).exists?(challenge_id: @team.challenge_id)
      flash[:error] = 'You are a member of a different team for this challenge'
      redirect_to @team.challenge
    end
    return if performed?

    ActiveRecord::Base.transaction do
      # accept/reject invitations where user is invited
      TeamInvitation\
        .joins(:team)
        .where(teams: { challenge_id: @team.challenge_id })
        .where(invitee_id: current_participant.id)
        .where.not(status: :canceled)
        .each do |inv|
          inv.update_attributes!(
            status: (inv.id == @invitation.id ? :accepted : :rejected)
          )
        end
      # destroy personal team
      Team\
        .joins(:team_members)
        .where(team_members: { participant_id: current_participant, role: :organizer })
        .first
        .destroy!
      # become a member of the team
      @team.team_participants.create!(participant_id: current_participant.id)
    end
    redirect_to @team
    # error when accepting should take user to challenge page with flash describing why
  end

  private def set_team
    @team = Team.find_by!(name: params[:team_name])
  end

  private def set_invitation
    @invitation = @team.team_invitations.find(params[:id])
  end
end
