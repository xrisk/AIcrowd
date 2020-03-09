module Api
  module Discourse
    class WebhooksController < ActionController::API
      before_action :authenticate!, only: :create

      def create
        head :ok
      end

      private

      def authenticate!
        return render json: { error: 'Not Authorized' }, status: :unauthorized unless valid_credentials?
      end

      def valid_credentials?
        Devise.secure_compare(ENV['DISCOURSE_WEBHOOKS_USERNAME'], params[:username]) &&
          Devise.secure_compare(ENV['DISCOURSE_WEBHOOKS_API_KEY'], params[:api_key])
      end
    end
  end
end
