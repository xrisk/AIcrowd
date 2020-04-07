class SubmissionCodeJob < ApplicationJob
  queue_as :default

  def perform(submission_id)
    submission = Submission.find(submission_id)
    SubmissionService.new(submission_id: submission.id).call if submission.present?
  end
end
