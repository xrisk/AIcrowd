class Challenges::TeamsController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_challenge

  def create
    authorize @challenge, :create_team?
    @team = @challenge.teams.new(create_team_attributes)
    @team.team_participants.build(participant_id: current_participant.id, role: :organizer)

    if @team.save
      BaseLeaderboard.morph_submitter!(
        from: current_participant,
        to: @team,
        challenge_id: @challenge.id,
      )
      flash[:success] = 'Team created successfully'
      redirect_to @team
    else
      flash[:error] = @team.errors.full_messages.to_sentence
      redirect_to @challenge
    end
  end

  private def set_challenge
    @challenge = Challenge.friendly.find(params[:challenge_id])
  end

  private def create_team_attributes
    params
      .fetch(:team, {})
      .permit(:name)
  end
end
