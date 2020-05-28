module Admins
  class OrganizerApplicationNotificationJob < ApplicationJob
    queue_as :default

    def perform(organizer_application_id)
      organizer_application = OrganizerApplication.find(organizer_application_id)

      Participant.admins.each do |participant|
        Admin::NotificationsMailer.organizer_application_notification_email(participant, organizer_application).deliver_later
      end
    end
  end
end
