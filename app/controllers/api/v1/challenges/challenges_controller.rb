module Api
  module V1
    module Challenges
      class ChallengesController < ::Api::V1::BaseController
        before_action :auth_by_participant_api_key, only: [:create, :update]
        before_action :set_challenge, only: :update

        def create
          authorize Challenge.new, :api_create?

          result = ::Challenges::ImportService.new(import_params: params).call

          if result.success?
            render json: Api::V1::ChallengeSerializer.new(challenge: result.value).serialize, status: :created
          else
            render json: { error: result.value }, status: :unprocessable_entity
          end
        end

        def update
          result = ::Challenges::ImportService.new(
            import_params: params,
            challenge:     @challenge
          ).call

          if result.success?
            render json: Api::V1::ChallengeSerializer.new(challenge: @challenge).serialize, status: :ok
          else
            render json: { error: result.value }, status: :unprocessable_entity
          end
        end

        private

        def set_challenge
          @challenge = Challenge.friendly.find(params[:id])
          authorize @challenge, :edit?
        end
      end
    end
  end
end
