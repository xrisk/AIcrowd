module Concerns
  module ChallengeMasthead
    extend ActiveSupport::Concern

    module ClassMethods
      def challenge_masthead_actions(actions)
        before_action :set_challenge, only: actions
        before_action :set_challenge_rounds, only: actions
        before_action :set_vote, only: actions
        before_action :set_follow, only: actions
      end
    end

    private

    def set_challenge
      @challenge = Challenge.friendly.find(params[:challenge_id])

      @meta_challenge = Challenge.includes(:organizers).friendly.find(params[:meta_challenge_id]) if params.has_key?('meta_challenge_id')
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
