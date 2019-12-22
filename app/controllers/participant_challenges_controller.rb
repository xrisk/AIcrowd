class ParticipantChallengesController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_challenge, only: [:index, :approve, :deny]
  respond_to :html, :js

  def index
    @count_of_unknown = @challenge.challenge_participants.where(participant_id: nil).count
    @participant_challenges = @challenge
                                  .challenge_participants
                                  .where.not(participant_id: nil)
                                  .order('updated_at asc')
                                  .page(params[:page])
                                  .per(10)
    authorize @participant_challenges
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

end
