module Admins
  class SubmissionNotificationJob < ApplicationJob
    queue_as :default

    def perform(submission_id)
      submission = Submission.find(submission_id)

      Participant.admins.with_every_email_preference.each do |participant|
        Admin::NotificationsMailer.submission_notification_email(participant, submission).deliver_later
      end
    end
  end
end
