class ParticipantChallengesController < ApplicationController
  include Concerns::ChallengeMasthead
  challenge_masthead_actions [:index]

  before_action :authenticate_participant!

  respond_to :html, :js

  def index
    @count_of_unknown       = @challenge.challenge_participants.where(participant_id: nil).count
    @participant_challenges = @challenge
                              .challenge_participants
                              .where.not(participant_id: nil)
                              .order('updated_at asc')
                              .page(params[:page])
                              .per(10)
    authorize @participant_challenges
  end
end
