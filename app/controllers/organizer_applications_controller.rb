class OrganizerApplicationsController < ApplicationController
  respond_to :js

  def create
    organizer_application = OrganizerApplication.create!(organizer_application_params)

    Participant.admins.each do |participant|
      Admin::NotificationsMailer.organizer_application_notification_email(participant, organizer_application).deliver_later
    end

    OrganizerApplicationNotificationJob.perform_later(organizer_application)
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
        :challenge_description)
  end
end
