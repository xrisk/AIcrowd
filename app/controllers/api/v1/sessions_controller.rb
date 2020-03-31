module Api
  module V1
    class SessionsController < Api::BaseController
      def show
        if current_participant.present?
          render json: { logged_in: true, user_name: current_participant.name, user_email: current_participant.email }, status: :ok
        else
          render json: { logged_in: false }, status: :ok
        end
      end
    end
  end
end
