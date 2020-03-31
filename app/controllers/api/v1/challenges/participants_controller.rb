module Api
  module V1
    module Challenges
      class ParticipantsController < ActionController::API
        before_action :set_challenge

        def search
          participants = @challenge.participants.where('participants.name ILIKE ?', "%#{params[:q]}%").limit(100)

          render json: Api::V1::Challenges::SearchParticipantsSerializer.new(participants: participants).serialize, status: :ok
        end

        private

        def set_challenge
          @challenge = Challenge.friendly.find(params[:challenge_id])
        end
      end
    end
  end
end
