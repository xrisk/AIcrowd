class ParticipantMlChallengeGoalsController < ApplicationController
  before_action :authenticate_participant!

  before_action :set_challenge, only: [:create]

  def create
    participant_ml_challenge_goal = @challenge.participant_ml_challenge_goals.create!(participant_ml_challenge_goal_params)

    if participant_ml_challenge_goal
      redirect_to @challenge
    else
      redirect_to daily_practice_goals_path(challenge_id: @challenge.slug)
    end
  end

  private

  def participant_ml_challenge_goal_params
    params.require(:participant_ml_challenge_goal).permit(:participant_id, :daily_practice_goal_id)
  end

  def set_challenge
    @challenge = Challenge.friendly.find(params[:participant_ml_challenge_goal]["challenge_id"])
  end
end
