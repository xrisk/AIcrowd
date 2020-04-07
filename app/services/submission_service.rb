class SubmissionService
  include HTTParty
  debug_output $stdout
  base_uri ENV["API_SERVER"]

  # SubmissionService.new(submission_id: 1).call

  def initialize(submission_id:)
    @submission = Submission.find(submission_id)
  end

  def call
    @login_body = login_params
    if @login_body
      @authorization = get_token
      if @authorization.present?
        response = code_submission
      end
    end
  end

  def get_token
    response = self.class.post("/auth/login", headers: header, body: @login_body, verify: false)
    return response.parsed_response['Authorization']
  rescue StandardError => e
    e.message
    raise e
  end

  def code_submission
    response = self.class.post("/submissions", headers: login_header, body: submission_params, verify: false)
    return response
  rescue StandardError => e
    e.message
    raise e
  end

  private

  def header
    {"Content-Type": "application/json"}
  end

  def login_params
    {email: ENV["API_USER_EMAIL"], password: ENV["API_USER_PASSWORD"]}.to_json
  end

  def login_header
    {"Accept": "application/json", "Authorization": @authorization}
  end

  def submission_params
    {
      participant_id: @submission.participant_id,
      grader_id: @submission.challenge.grader_identifier,
      round_id: 0,
      submission_data: {
        type: "ruby", # we need to get code lang to participant
        code: @submission.code_data
      }
    }.to_json
  end
end
