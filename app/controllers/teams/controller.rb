class Teams::Controller < ApplicationController
  before_action :authenticate_participant!, except: [:show]
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  def show
    @pending_invitations = @team.team_invitations
      .status_pendings
      .includes(:invitee)
  end

  private def set_team
    @team = Team.find_by!(name: params[:name])
    authorize @team
  end
end
