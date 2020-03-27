module Api
  module V1
    module Challenges
      class TeamsController < ActionController::API
        before_action :set_challenge

        def search
          teams = @challenge.teams.where('teams.name ILIKE ?', "%#{params[:q]}%").limit(100)

          render json: Api::V1::Challenges::SearchTeamsSerializer.new(teams: teams).serialize, status: :ok
        end

        private

        def set_challenge
          @challenge = Challenge.includes(teams: :participants).friendly.find(params[:challenge_id])
        end
      end
    end
  end
end
