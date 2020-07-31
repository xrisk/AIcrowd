class SubmissionsController < ApplicationController
  before_action :authenticate_participant!, except: [:index, :show]
  before_action :set_submission, only: [:show, :edit, :update]
  before_action :set_challenge
  before_action :set_challenge_rounds, only: [:index, :new, :create, :show]
  before_action :set_vote, only: [:index, :new, :create, :show]
  before_action :set_follow, only: [:index, :new, :create, :show]
  before_action :check_participation_terms, except: [:show, :index, :export]
  before_action :set_s3_direct_post, only: [:new, :edit, :create, :update]
  before_action :set_submissions_remaining, except: [:show, :index]
  before_action :set_current_round, only: [:index, :new, :create]
  before_action :set_form_type, only: [:new, :create]
  before_action :handle_code_based_submissions, only: [:create]
  before_action :handle_artifact_based_submissions, only: [:create]

  layout :set_layout
  respond_to :html, :js

  def index
    if params[:baselines] == 'true'
      filter     = policy_scope(Submission)
                   .where(
                     challenge_round_id: @current_round&.id,
                     challenge_id:       @challenge.id,
                     baseline:           true
                   )
                   .where.not(participant_id: nil)
      @baselines = true
    else
      @baselines      = false
      @my_submissions = true if params[:my_submissions] == 'true' && current_participant
      if @my_submissions
        filter                 = policy_scope(Submission)
                                 .where(
                                   challenge_round_id: @current_round&.id,
                                   challenge_id:       @challenge.id,
                                   participant_id:     current_participant.id
                                 )
        @submissions_remaining = SubmissionsRemainingQuery.new(
          challenge:      @challenge,
          participant_id: current_participant.id
        ).call
      else
        filter = policy_scope(Submission)
                 .where(
                   challenge_round_id: @current_round&.id,
                   challenge_id:       @challenge.id
                 )
                 .freeze_record(current_participant)

      end
    end
    filter = if @meta_challenge.present?
               filter.where(meta_challenge_id: @meta_challenge.id)
             else
               filter.where(meta_challenge_id: nil)
             end

    if @challenge.meta_challenge
      params[:meta_challenge_id] = @challenge.slug
      filter                     = policy_scope(Submission)
                                   .where(challenge_round_id: @challenge.meta_active_round_ids,
                                          meta_challenge_id:  @challenge.id)
      filter                     = filter.where(participant_id: current_participant.id) if @my_submissions
    end
    @search       = filter.search(search_params)
    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @submissions  = @search.result.includes(:participant).page(params[:page]).per(10)
  end

  def filter
    Rails.logger.debug('PARAMS Q')
    Rails.logger.debug(params[:q])
    @search      = policy_scope(Submission).ransack(params[:q])
    @submissions = @search.result
                          .where(challenge_id: @challenge.id)
                          .page(1).per(10)
    render @submissions
  end

  def show
    @presenter = SubmissionDetailPresenter.new(
      submission:   @submission,
      challenge:    @challenge,
      view_context: view_context
    )
    render :show
  end

  def new
    @clef_primary_run_disabled          = clef_primary_run_disabled?
    @submissions_remaining, @reset_dttm = SubmissionsRemainingQuery.new(
      challenge:      @challenge,
      participant_id: current_participant.id
    ).call
    @submission                         = @challenge.submissions.new
    @submission.submission_files.build
    authorize @submission
  end

  def create
    session_info                     = { participant_id: current_participant.id, online_submission: true }
    session_info[:meta_challenge_id] = @meta_challenge.id if @meta_challenge.present?
    session_info[:ml_challenge_id]   = @ml_challenge.id if @ml_challenge.present?
    @submission                      = @challenge.submissions.new(submission_params.merge(session_info))
    authorize @submission

    validate_submission_file_presence
    if @submission.errors.none? && @submission.save
      SubmissionGraderJob.perform_later(@submission.id)
      redirect_to helpers.challenge_submissions_path(@challenge), notice: 'Submission accepted.'
    else
      @submission.submission_files.build
      flash[:error] = @submission.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    authorize @submission
  end

  def update
    authorize @submission
    if @submission.update(submission_params)
      redirect_to @challenge,
                  notice: 'Submission updated.'
    else
      flash[:error] = @submission.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    submission = Submission.find(params[:id])
    submission.destroy
    redirect_to helpers.challenge_leaderboards_path(@challenge), notice: 'Submission was successfully destroyed.'
  end

  def export
    authorize @challenge, :export?

    @submissions = @challenge.submissions
                             .includes(:participant, :challenge_round)
                             .where(challenge_round_id: params[:submissions_export_challenge_round_id].to_i)

    csv_data = Submissions::CSVExportService.new(submissions: @submissions).call.value

    send_data csv_data,
              type:     'text/csv',
              filename: "#{@challenge.challenge.to_s.parameterize.underscore}_submissions_export.csv"
  end

  private

  def set_submission
    @submission = Submission.find(params[:id])
    authorize @submission
  end

  def set_challenge
    @challenge     = Challenge.friendly.find(params[:challenge_id])
    challenge_type = params['ml_challenge_id'].present? ? 'ml_challenge_id' : 'meta_challenge_id'

    if params.has_key?(challenge_type) && params[challenge_type.to_sym] != params[:challenge_id]
      if params['ml_challenge_id'].present?
        @ml_challenge = Challenge.includes(:organizers).friendly.find(params[challenge_type
          .to_sym])
      else
        @meta_challenge = Challenge.includes(:organizers).friendly.find(params[challenge_type
          .to_sym])
      end
    elsif @challenge.meta_challenge || @challenge.ml_challenge
      params[challenge_type.to_sym] = params[:challenge_id]
    end

    unless params.has_key?(challenge_type)
      cp = ChallengeProblems.find_by(problem_id: @challenge.id)
      if cp.present?
        params[challenge_type.to_sym] = Challenge.find(cp.challenge_id).slug
        redirect_to helpers.challenge_submissions_path(@challenge)
      end
    end
  end

  def set_challenge_rounds
    @challenge_rounds = @challenge.challenge_rounds.started
  end

  def set_vote
    @vote = @challenge.votes.where(participant_id: current_participant.id).first if current_participant.present?
  end

  def set_follow
    @follow = @challenge.follows.where(participant_id: current_participant.id).first if current_participant.present?
  end

  def set_current_round
    @current_round = if params[:challenge_round_id].present?
                       @challenge.challenge_rounds.find(params[:challenge_round_id].to_i)
                     else
                       @challenge.active_round || @challenge.challenge_rounds.first
                     end
  end

  def set_form_type
    @form_type = @current_round&.submissions_type || 'artifact'
  end

  def check_participation_terms
    challenge = @challenge
    challenge = @meta_challenge if @meta_challenge.present?

    unless policy(challenge).has_accepted_participation_terms?
      redirect_to [challenge, ParticipationTerms.current_terms]
      return
    end

    unless policy(challenge).has_accepted_challenge_rules?
      redirect_to challenge_challenge_rules_path(challenge)
      nil
    end
  end

  def grader_logs
    if @challenge.grader_logs
      s3_key       = "grader_logs/#{@challenge.slug}/grader_logs_submission_#{@submission.id}.txt"
      s3           = S3Service.new(s3_key)
      @grader_logs = s3.filestream
    end
    @grader_logs
  end

  def submission_params
    params
      .require(:submission)
      .permit(
        :ml_challenge_id,
        :meta_challenge_id,
        :challenge_id,
        :participant_id,
        :description_markdown,
        :score,
        :score_secondary,
        :grading_status,
        :grading_message,
        :api,
        :grading_status_cd,
        :media_content_type,
        :media_thumbnail,
        :media_large,
        :docker_configuration_id,
        :clef_method_description,
        :clef_retrieval_type,
        :clef_run_type,
        :clef_primary_run,
        :clef_other_info,
        :clef_additional,
        :online_submission,
        :baseline,
        :baseline_comment,
        :submission_link,
        submission_files_attributes: [
          :id,
          :seq,
          :submission_file_s3_key,
          :submission_type,
          :_delete
        ]
      )
  end

  def get_s3_key
    "submission_files/challenge_#{@challenge.id}/#{SecureRandom.uuid}_${filename}"
  end

  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET.presigned_post(key: get_s3_key, success_action_status: '201', acl: 'private')
  end

  def handle_code_based_submissions
    return if params[:submission][:submission_type] != 'code'

    file_location = get_s3_key.gsub('${filename}', 'editor_input.' + params[:language])
    begin
      S3_BUCKET.object(file_location).put(body: params[:submission][:submission_data])
    rescue Aws::S3::Errors::ServiceError
      redirect_to helpers.challenge_submissions_path(@challenge), notice: 'Submission upload failed, please try again.'
    end

    params[:submission].merge!({
                                 submission_files_attributes: { "0": { seq: '', submission_type: params[:language], submission_file_s3_key: file_location } }
                               })
  end

  def handle_artifact_based_submissions
    return if params.dig('submission', 'submission_files_attributes', '0', 'submission_type') != 'artifact'

    # TODO: Make this accepted extension list dynamic via evaluations API
    accepted_formats = ['.csv', '.ipynb', '.pt', '.json', '.py', '.c', '.cpp']
    file_path        = params[:submission][:submission_files_attributes]['0'][:submission_file_s3_key]

    return if file_path.blank?

    extension                                                                = File.extname(file_path)
    params[:submission][:submission_files_attributes]['0'][:submission_type] = extension.gsub(/^./, '') if accepted_formats.include?(extension)
  end

  def set_submissions_remaining
    @submissions_remaining = @challenge.submissions_remaining(current_participant.id)
  end

  def notify_admins
    Admins::SubmissionNotificationJob.perform_later(@submission.id)
  end

  def clef_primary_run_disabled?
    return true unless @challenge.organizers.any? { |organizer| organizer.clef? }

    sql = %[
        SELECT 'X'
        FROM submissions s
        WHERE s.challenge_id = #{@challenge.id}
        AND s.participant_id = #{current_participant.id}
        AND ((s.clef_primary_run IS TRUE
              AND s.grading_status_cd = 'graded')
              OR s.grading_status_cd IN ('ready', 'submitted', 'initiated'))
      ]
    res = ActiveRecord::Base.connection.select_values(sql)
    res.any?
  end

  def set_layout
    'application'
  end

  def validate_submission_file_presence
    @submission.errors.add(:base, 'Submission file is required.') if @form_type == 'artifact' && @submission.submission_files.none?
  end
end
