module Organizers
  class EuaNotificationJob < ApplicationJob
    queue_as :default

    def perform(clef_task_id, current_participant_id)
      clef_task           = ClefTask.find(clef_task_id)
      current_participant = Participant.find(current_participant_id)

      clef_task.organizer.participants.where(clef_email: true).each do |organizer_participant|
        Organizers::NotificationsMailer.eua_notification_email(organizer_participant, clef_task, current_participant).deliver_later
      end
    end
  end
end
