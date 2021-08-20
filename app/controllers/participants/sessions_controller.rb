class Participants::SessionsController < Devise::SessionsController
  after_action :save_user_profile_to_mixpanel, only: [:create]

  def save_user_profile_to_mixpanel
    if resource.present?
      Mixpanel::SyncJob.perform_later(resource, request.remote_ip)
    end
  end
end
