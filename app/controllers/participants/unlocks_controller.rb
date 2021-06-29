class Participants::UnlocksController < Devise::UnlocksController
  before_action :verify_captcha, only: [:create]

  def verify_captcha
    unless verify_recaptcha
      redirect_to new_participant_session_path
    end
  end
end