module Api
  module V1
    class ApiUsersController < ::Api::V1::BaseController
      before_action :auth_by_participant_api_key, only: :show

      def show
        render json: Api::V1::ApiUserSerializer.new(participant: @api_user).serialize, status: :ok
      end
    end
  end
end
