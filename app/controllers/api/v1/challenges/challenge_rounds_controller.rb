module Api
  module V1
    module Challenges
      class ChallengeRoundsController < Api::V1::BaseController
        before_action :auth_by_participant_api_key, only: [:create, :update]
        before_action :set_challenge, only: [:create, :update, :destroy]
        before_action :set_challenge_round, only: [:update, :destroy]

        def create
          challenge_round = @challenge.challenge_rounds.new(challenge_round_params)

          if challenge_round.save
            render json: Api::V1::ChallengeRoundSerializer.new(challenge_round: challenge_round).serialize, status: :created
          else
            render json: { error: challenge_round.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        end

        def update
          if @challenge_round.update(challenge_round_params)
            render json: Api::V1::ChallengeRoundSerializer.new(challenge_round: @challenge_round).serialize, status: :ok
          else
            render json: { error: @challenge_round.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        end

        def destroy
          if @challenge_round.destroy
            head :ok
          else
            render json: { error: @challenge_round.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        end

        private

        def challenge_round_params
          params.require(:challenge_round).permit(
            :challenge_round,
            :active,
            :submission_limit,
            :submission_limit_period_cd,
            :start_dttm,
            :end_dttm,
            :minimum_score,
            :minimum_score_secondary,
            :submissions_type
          )
        end

        def set_challenge
          @challenge = Challenge.friendly.find(params[:challenge_id])

          authorize @challenge, :edit?
        end

        def set_challenge_round
          @challenge_round = @challenge.challenge_rounds.find(params[:id])
        end
      end
    end
  end
end
