class Participants::PasswordsController < Devise::PasswordsController
  before_action :check_captcha, only: [:create]

  def check_captcha
    byebug
    unless verify_recaptcha
      redirect_to new_participant_session_path
    end
  end
end