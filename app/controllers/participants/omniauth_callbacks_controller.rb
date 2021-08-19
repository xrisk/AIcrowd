class Participants::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth2_generic
  end

  def oauth2_generic
    @user = from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      Mixpanel::SyncJob.perform_later(@user, request.remote_ip)
      if !@user.confirmed?
        Mixpanel::EventJob.perform_later(@user, 'Registration Complete', {
          'Registration Method': readable_provider_name(action_name),
        })
        @user.confirm
        token = @user.send(:set_reset_password_token)
        redirect_to edit_password_path(@user, reset_password_token: token)
      else
        Mixpanel::EventJob.perform_later(@user, 'Login Complete', {
          'Login Method': readable_provider_name(action_name),
          'User Type': @user.user_type
        })
        set_flash_message(:notice, :success, kind: @user.provider) if is_navigational_format?
        sign_in_and_redirect @user, event: :authentication
      end
    else
      session['devise.omniauth_data'] = request.env['omniauth.auth']
      redirect_to new_participant_registration_path
    end
  end

  def failure
    redirect_to root_path
  end

  def google_oauth2
    oauth2_generic
  end

  def readable_provider_name(provider_name)
    case provider_name
    when 'google_oauth2'
      return 'Google'
    when 'oauth2_generic'
      return 'CrowdAi'
    when 'github'
      return 'GitHub'
    else
      return provider_name
    end
  end

  private

  def from_omniauth(auth)
    email     = auth.info.email
    participant = Participant.find_by(email: email)
    return participant if participant.present? && participant.confirmed?

    username  = auth.info.name
    username  = username.gsub(/\s+/, '_').downcase
    username  = sanitize_userhandle(username)
    image_url = auth.info.image
    provider  = readable_provider_name(auth.provider)

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
    username = userhandle.to_ascii
      .tr("@", "a")
      .gsub("&", "and")
      .delete('#')
      .delete('*')
      .gsub(/[\,\.\'\;\-\=]/, "")
      .gsub(/[\(\)]/, "_")
      .tr(' ', "_")

    while Participant.where(name: username).exists?
      username = username + rand(1..9).to_s
    end
    username
  end
end
