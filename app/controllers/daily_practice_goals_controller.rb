class DailyPracticeGoalsController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_challenge, only: [:index]

  def index
    @goals           = DailyPracticeGoal.all
    @goal_commitment = @challenge.participant_ml_challenge_goals.new
  end

  private

  def set_challenge
    @challenge = Challenge.friendly.find(params[:challenge_id])
  end
end
