require 'aicrowd_evaluations'

class EvaluationsApiService
  def initialize(submission_id:)
    @submission = Submission.find(submission_id)
    @grader_id  = @submission.challenge.challenge_client_name.to_i
  end

  def call
    grader = get_grader
    create_submission(grader.id)
  rescue StandardError => e
    @submission.update!(
      grading_status:  'failed',
      grading_message: e.message
    )
    raise e
  end

  private

  def create_submission(grader_id)
    artifact            = get_submission_artifact
    attribute           = {
      grader_id:       grader_id,
      meta:            {
        participant_id:        @submission.participant.id,
        round_id:              @submission.challenge_round_id,
        submission_id:         @submission.id,
        challenge_client_name: @submission.challenge.challenge_client_name,
        domain_name:           ENV['DOMAIN_NAME'],
        aicrowd_token:         ENV['AICROWD_API_KEY']
      }.to_json,
      submission_data: {
        type: artifact.submission_type,
        # TODO: Directly submit s3 url as submission instead of downloading
        code: download_s3_file(artifact.submission_file_s3_key)
      }
    }
    payload             = AIcrowdEvaluations::Submissions.new attribute
    submission_api      = AIcrowdEvaluations::SubmissionsApi.new
    submission_response = submission_api.create_submission(payload)
    @submission.update!(
      grading_status:  'submitted',
      grading_message: 'Evaluating...'
    )
  end

  def get_grader
    # TODO: Use the client names instead of grader_id
    grader_api = AIcrowdEvaluations::GradersApi.new
    grader     = grader_api.get_grader(@grader_id)
    if grader.status != 'Completed'
      message = 'Grader not ready for submissions'
      @submission.update!(
        grading_status:  'failed',
        grading_message: message
      )
      raise message
    end
    grader
  end

  def get_submission_artifact
    @submission.submission_files.first
  end

  def download_s3_file(file_key)
    S3_BUCKET.object(file_key).get.body.string
  end
end
