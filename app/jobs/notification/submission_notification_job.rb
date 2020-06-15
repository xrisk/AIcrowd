class Notification::SubmissionNotificationJob < ApplicationJob
  queue_as :default

  def perform(submission_id)
    submission = Submission.find(submission_id)
    NotificationService.new(submission.participant_id, submission, submission.grading_status_cd).call
  end
end
