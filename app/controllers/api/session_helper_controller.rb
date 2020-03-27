require 'cgi'
require 'active_support'

class Api::SessionHelperController < Api::BaseController
  respond_to :json

  def check_login
    result      = SessionService.new(params[:aicrowd_cookie]).call
    participant = Participant.find_by(id: result["warden.user.participant.key"][0]) if result.present? && !result["warden.user.participant.key"].nil?

    if participant.present?
      render json: { logged_in: true, user_name: participant.name, user_email: participant.email }, status: :ok
    else
      render json: { logged_in: false }, status: :ok
    end
  end
end
