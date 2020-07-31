class OrganizerApplicationsController < ApplicationController
  respond_to :js

  def create
    organizer_application = OrganizerApplication.create!(organizer_application_params)

    Admins::OrganizerApplicationNotificationJob.perform_later(organizer_application.id)

    Organizers::NotificationsMailer.received_application_email(organizer_application).deliver_later
  end

  private

  def organizer_application_params
    params
      .require(:organizer_application)
      .permit(
        :contact_name,
        :email,
        :phone,
        :organization,
        :organization_description,
        :challenge_description
      )
  end
end
