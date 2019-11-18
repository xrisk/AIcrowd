class Challenges::TeamInvitationsController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_challenge
  before_action :set_team
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]
  before_action :redirect_on_create_disallowed, only: :create

  def create
    if @team.invitations_left.positive?
      @invitation = @team.team_invitations.new(
          invitor: current_participant,
          invitee: @invitee,
      )

      if @invitation.save
        Team::InvitationPendingNotifierJob.perform_later(@invitation.id)
        flash[:success] = 'The invitation was sent'
      else
        flash[:error] = 'An error occurred. The invitation was not sent.'
      end
    else
      flash[:error] = 'The invitation was not sent. No invitations left.'
    end
    redirect_to challenge_team_path(@team.challenge, @team)
  end

  private def set_challenge
    @challenge = Challenge.friendly.find(params[:challenge_id])
  end

  private def set_team
    @team = @challenge.teams.find_by!(name: params[:team_name])
  end

  private def set_invitation
    @invitation = @team.team_invitations.find(params[:id])
  end

  private def redirect_on_create_disallowed
    authorize @team, :create_invitations?
    @invitee = Participant.where('LOWER(name) = LOWER(?)', params[:name]).first
    if @invitee.nil?
      flash[:error] = 'Participant with that name could not be found'
      redirect_to challenge_team_path(@team.challenge, @team)
    elsif @invitee.concrete_teams.find_by(challenge_id: @team.challenge_id).present?
      flash[:error] = 'Participant with that name is already on a team'
      redirect_to challenge_team_path(@team.challenge, @team)
    end
  end
end
