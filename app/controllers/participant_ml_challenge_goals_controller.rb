class ParticipantMlChallengeGoalsController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_challenge

  def new
    @goals           = DailyPracticeGoal.all
    @goal_commitment = @challenge.participant_ml_challenge_goals.new
  end

  def create
    participant_ml_challenge_goal = @challenge.participant_ml_challenge_goals.create!(participant_ml_challenge_goal_params)

    if participant_ml_challenge_goal
      redirect_to @challenge
    else
      redirect_to daily_practice_goals_path(challenge_id: @challenge.slug)
    end
  end

  def edit
    @goals           = DailyPracticeGoal.all
    @goal_commitment = @challenge.participant_ml_challenge_goals.find_by(participant_id: current_participant.id)
  end

  def update
    @goal_commitment = @challenge.participant_ml_challenge_goals.find_by(participant_id: current_participant.id)
    if @goal_commitment.update(participant_ml_challenge_goal_params)
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
    challenge_id = params[:participant_ml_challenge_goal].presence ? params[:participant_ml_challenge_goal]['challenge_id'] : params["challenge_id"]

    @challenge   = Challenge.friendly.find(challenge_id)
  end
end
