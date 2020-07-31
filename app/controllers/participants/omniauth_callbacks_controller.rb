class Participants::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth2_generic
  end

  def oauth2_generic
    @user = from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      if !@user.confirmed?
        @user.confirm
        token = @user.send(:set_reset_password_token)
        redirect_to edit_password_path(@user, reset_password_token: token)
      else
        set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
        sign_in_and_redirect @user
      end
    else
      session['devise.omniauth_data'] = request.env['omniauth.auth']
      redirect_to new_participant_registration_path
    end
  end

  def failure
    redirect_to root_path
  end

  private

  def from_omniauth(auth)
    email     = auth.info.email
    username  = auth.info.name
    username  = username.gsub(/\s+/, '_').downcase
    username  = sanitize_userhandle(username)
    image_url = auth.info.image
    provider  = auth.provider
    provider  = 'crowdai' if provider == 'oauth2_generic'

    participant                       = Participant.where(email: email).first_or_initialize
    participant.password              = Devise.friendly_token[0, 20]
    participant.name                  = username
    participant.provider              = provider
    participant.remote_image_file_url = image_url if image_url.present?
    ### We want to skip the notification but leave the user unconfirmed which will allow us to force a password reset on first login
    participant.skip_confirmation_notification!
    participant.save

    participant
  end

  def sanitize_userhandle(userhandle)
    userhandle.to_ascii
              .tr('@', 'a')
              .gsub('&', 'and')
              .delete('#')
              .delete('*')
              .gsub(/[\,\.\'\;\-\=]/, '')
              .gsub(/[\(\)]/, '_')
              .tr(' ', '_')
  end
end
