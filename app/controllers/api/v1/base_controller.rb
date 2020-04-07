module Api
  module V1
    class BaseController < ActionController::API
      include Pundit

      rescue_from Pundit::NotAuthorizedError, with: :not_authorized_message

      protected

      def not_authorized_message
        render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
      end

      def pundit_user
        current_participant
      end

      def current_user
        current_participant
      end
    end
  end
end
