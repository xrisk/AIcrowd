class ParticipantChallengesController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_challenge, only: [:index,:approve,:deny]
  respond_to :html, :js

  def index
    @participant_challenges = @challenge
      .challenge_participants
      .order('CASE WHEN participant_id IS NULL THEN 2 ELSE 1 END, updated_at asc')
      .page(params[:page])
      .per(10)
    authorize @participant_challenges
  end

  private
  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

end
