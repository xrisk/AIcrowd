module Api
  module V1
    module Challenges
      class ChallengesController < ::Api::V1::BaseController
        include ActionController::Helpers
        helper ChallengesHelper
        helper VotesHelper
        helper FollowsHelper

        before_action :auth_by_participant_api_key, only: [:create, :update, :masthead]
        before_action :set_challenge, only: [:update]
        before_action :set_challenge_to_discource, only: [:masthead]
        before_action :set_challenge_rounds, only: [:masthead]
        before_action :set_vote, only: [:masthead]
        before_action :set_follow, only: [:masthead]

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

        def masthead
          render json: {
            masthead:
                      render_to_string(
                        partial: 'shared/challenges/masthead',
                        formats: :html,
                        layout:  false,
                        locals:  { challenge: @challenge, challenge_rounds: @challenge_rounds, vote: @vote, follow: @follow }
                      )
          }
        end

        private

        def set_challenge
          @challenge = Challenge.friendly.find(params[:id])
          authorize @challenge, :edit?
        end

        def set_challenge_to_discource
          @challenge = Challenge.where(discourse_category_id: params[:id]).first
        end

        def set_challenge_rounds
          @challenge_rounds = @challenge.challenge_rounds.started
        end

        def set_vote
          @vote = @challenge.votes.where(participant_id: @api_user.id).first if @api_user.present?
        end

        def set_follow
          @follow = @challenge.follows.where(participant_id: @api_user.id).first if @api_user.present?
        end
      end
    end
  end
end
