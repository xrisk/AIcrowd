module Challenges
  class BaseController < ApplicationController
    before_action :set_challenge
    before_action :set_challenge_rounds
    before_action :set_vote
    before_action :set_follow
    before_action :set_current_round

    private

    def set_challenge
      @challenge = Challenge.friendly.find(params[:challenge_id])
    end

    def set_current_round
      @current_round = if params[:challenge_round_id].present?
                        @challenge.challenge_rounds.find(params[:challenge_round_id].to_i)
                      else
                        @challenge.active_round
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
