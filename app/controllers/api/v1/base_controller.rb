module Api
  module V1
    class BaseController < ActionController::API
      include ::ActionController::HttpAuthentication::Token::ControllerMethods
      include Pundit

      rescue_from Pundit::NotAuthorizedError, with: :not_authorized_message

      protected

      def auth_by_participant_api_key
        authenticate_or_request_with_http_token do |token, options|
          @api_user = Participant.find_by(api_key: token)
          (token == ENV['CROWDAI_API_KEY'] || @api_user.present?)
        end
      end

      def not_authorized_message
        render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
      end

      def api_user
        @api_user
      end

      def pundit_user
        api_user || current_participant
      end

      def current_user
        api_user || current_participant
      end
    end
  end
end
