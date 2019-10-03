class Teams::Invitations::Controller < ApplicationController
  before_action :authenticate_participant!
  before_action :set_team
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]
  before_action :set_invitee, only: :create
  before_action :redirect_on_create_disallowed, only: :create

  def create
    @invitation = @team.team_invitations.new(
      invitor: current_participant,
      invitee: @invitee,
    )

    if @invitation.save
      Team::InvitationPendingNotifierJob.perform_later(@invitation.id)
      flash[:success] = 'The invitation was sent.'
    else
      flash[:error] = 'An error occurred. The invitation was not sent.'
    end
    redirect_to @team
  end

  private def set_team
    @team = Team.find_by!(name: params[:team_name])
  end

  private def set_invitee
    name_or_email = params[:invitee_name_or_email] || ''
    @search_field = name_or_email =~ /\A[^@]+@[^@]+\z/ ? :email : :name
    case @search_field
    when :email
      @invitee = Participant.where('LOWER(email) = LOWER(?)', name_or_email).first
      @invitee ||= EmailInvitation.new(email: name_or_email)
    when :name
      @invitee = Participant.where('LOWER(name) = LOWER(?)', name_or_email).first
    end
  end

  private def set_invitation
    @invitation = @team.team_invitations.find(params[:id])
  end

  private def redirect_on_create_disallowed
    authorize @team, :create_invitations?
    if @team.invitations_left <= 0
      err = 'No invitations left.'
    elsif @invitee.nil?
      err = 'Participant with that name could not be found.'
    elsif @invitee.is_a?(Participant) && @invitee.concrete_teams.find_by(challenge_id: @team.challenge_id).present?
      err = 'Participant with that name is already on a team.'
    end
    if err
      flash[:error] = 'The invitation was not sent. ' + err
      redirect_to @team
    end
  end
end
