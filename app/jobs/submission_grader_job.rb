class SubmissionGraderJob < ApplicationJob
  queue_as :default

  def perform(submission_id)
    if get_evaluator_type(submission_id) == "evaluations_api"
      EvaluationsApiService.new(submission_id: submission_id).call
    else
      GraderService.new(submission_id: submission_id).call
    end
  end

  private

  def get_evaluator_type(submission_id)
    submission = Submission.find(submission_id)
    challenge_round = submission.challenge_round
    return challenge_round.evaluator_type_cd if challenge_round.evaluator_type_cd.present?

    challenge = submission.challenge
    return challenge.evaluator_type_cd
  end
end
