module Api
  module V1
    module Challenges
      class ChallengeRoundsController < Api::V1::BaseController
        before_action :set_challenge, only: :destroy

        def destroy
          challenge_round = @challenge.challenge_rounds.find(params[:id])

          if challenge_round.destroy
            head :ok
          else
            render json: { error: challenge_round.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        end

        private

        def set_challenge
          @challenge = Challenge.friendly.find(params[:challenge_id])

          authorize @challenge, :edit?
        end
      end
    end
  end
end
