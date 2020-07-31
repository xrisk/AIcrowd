module Api
  module V1
    module Sessions
      class HelpersController < ActionController::API
        respond_to :json

        def check_login
          if params[:aicrowd_cookie].present?
            result      = SessionService.new(params[:aicrowd_cookie]).call
            participant = Participant.find_by(id: result[:value]['warden.user.participant.key'][0]) if result.success

            if participant.present?
              render json: { logged_in: true, user_name: participant.name, user_email: participant.email }, status: :ok
            else
              render json: { logged_in: false }, status: :ok
            end
          else
            render json: { error: 'Did not get cookies in params' }
          end
        end
      end
    end
  end
end
