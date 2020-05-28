module Organizers
  class EuaNotificationJob < ApplicationJob
    queue_as :default

    def perform(organizer_id)
      organizer = Organizer.find(organizer_id)

      organizer.participants.where(clef_email: true).each do |organizer_participant|
        Organizers::NotificationsMailer.eua_notification_email(organizer_participant, clef_task, current_participant).deliver_later
      end
    end
  end
end
