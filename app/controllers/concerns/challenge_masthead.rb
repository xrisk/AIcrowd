module Concerns
  module ChallengeMasthead
    module ClassMethods
      attr_accessor :challenge_masthead_actions
    end

    extend ActiveSupport::Concern

    included do
      before_action :set_challenge, only: challenge_masthead_actions
      before_action :set_challenge_rounds, only: challenge_masthead_actions
      before_action :set_vote, only: challenge_masthead_actions
      before_action :set_follow, only: challenge_masthead_actions
    end

    private

    def set_challenge
      @challenge = Challenge.friendly.find(params[:challenge_id])

      if params.has_key?('meta_challenge_id')
        @meta_challenge = Challenge.includes(:organizers).friendly.find(params[:meta_challenge_id])
      end
    end

    def set_challenge_rounds
      @challenge_rounds = @challenge.challenge_rounds.started
    end

    def set_vote
      @vote = @challenge.votes.where(participant_id: current_participant.id).first if current_participant.present?
    end

    def set_follow
      @follow = @challenge.follows.where(participant_id: current_participant.id).first if current_participant.present?
    end
  end
end
