module Api
  module V1
    class BaseController < ActionController::API
      include ::ActionController::HttpAuthentication::Token::ControllerMethods
      include Pundit

      rescue_from Pundit::NotAuthorizedError, with: :not_authorized_message

      protected

      def auth_by_participant_api_key
        authenticate_or_request_with_http_token do |token, options|
          if token == ENV['CROWDAI_API_KEY']
            @api_user = Participant.api_admin

            true
          else
            @api_user = Participant.find_by(api_key: token)

            @api_user.present?
          end
        end
      end

      def not_authorized_message
        render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
      end

      def api_user
        @api_user
      end

      def current_participant
        api_user || super
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
