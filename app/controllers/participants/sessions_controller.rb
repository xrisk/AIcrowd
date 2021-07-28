class Participants::SessionsController < Devise::SessionsController
  after_action :save_user_profile_to_mixpanel, only: [:create, :update]

  def save_user_profile_to_mixpanel
    Mixpanel::SyncJob.perform_later(current_user, request.remote_ip)
  end
end
