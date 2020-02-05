class WinnersController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_challenge, only: :index
  before_action :set_challenge_rounds, only: :index

  def index; end

  private

  def set_challenge
    @challenge = Challenge.friendly.find(params[:challenge_id])
  end

  def set_challenge_rounds
    @challenge_rounds = @challenge.challenge_rounds.where("start_dttm < ?", Time.current)
  end
end
