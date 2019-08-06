class Teams::Invitations::Controller < ApplicationController
  before_action :authenticate_participant!
  before_action :set_team
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]
  before_action :redirect_on_create_disallowed, only: :create

  def create
    @invitation = @team.team_invitations.new(
      invitor: current_participant,
      invitee: @invitee,
    )

    if @invitation.save
      Team::InvitationPendingNotifierJob.perform_later(@invitation.id)
      flash[:success] = 'The invitation was sent'
      redirect_to @team
    else
      flash[:error] = 'An error occurred. The invitation was not sent.'
      redirect_to @team
    end
  end

  private def set_team
    @team = Team.find_by!(name: params[:team_name])
  end

  private def set_invitation
    @invitation = @team.team_invitations.find(params[:id])
  end

  private def redirect_on_create_disallowed
    authorize @team, :create_invitations?
    @invitee = Participant.where('LOWER(name) = LOWER(?)', params[:name]).first
    if @invitee.nil?
      flash[:error] = 'Participant with that name could not be found'
      redirect_to @team
    elsif @invitee.concrete_teams.find_by(challenge_id: @team.challenge_id).present?
      flash[:error] = 'Participant with that name is already on a team'
      redirect_to @team
    end
  end
end
