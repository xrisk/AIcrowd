class Teams::InvitationsController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_team
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]

  def create
    authorize @team, :create_invitations?
    @invitee = Participant.where('LOWER(email) = LOWER(?)', params[:email]).first
    if @invitee.nil?
      flash[:error] = 'Participant with that email could not be invited'
      redirect_to @team
      return
    end
    if @invitee.concrete_team(@team.challenge).present?
      flash[:error] = 'Participant with that email is already on a team'
      redirect_to @team
      return
    end

    @invitation = @team.team_invitations.new(
      invitor: current_participant,
      invitee: @invitee,
    )

    if @invitation.save
      flash[:success] = 'The invitation was sent'
      redirect_to @team
    else
      flash[:error] = 'An error occurred. The invitation was not sent.'
      redirect_to @team
    end
  end

  def destroy
    authorize @team, :create_invitations?
    if @invitation.destroy
      flash[:success] = 'Invitation cancelled'
      redirect_to @team
    else
      flash[:error] = 'An error occurred. The invitation was not cancelled'
      redirect_to @team
    end
  end

  private def set_team
    @team = Team.find_by!(name: params[:team_name])
  end

  private def set_invitation
    @invitation = @team.team_invitations.find(params[:id])
  end
end
