class ChallengesController < ApplicationController
  before_action :authenticate_participant!, except: [:show, :index]
  before_action :terminate_challenge, only: [:show, :index]
  before_action :set_challenge, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :show]
  before_action :set_s3_direct_post, only: [:edit, :update]
  before_action :set_organizer, only: [:new, :create, :edit, :update]

  respond_to :html, :js

  def index
    @challenge_filter = params[:challenge_filter] ||= 'all'
    @all_challenges   = policy_scope(Challenge)
    @challenges       = case @challenge_filter
                        when 'active'
                          @all_challenges.where(status_cd: ['running', 'starting_soon'])
                        when 'completed'
                          @all_challenges.where(status_cd: 'completed')
                        when 'draft'
                          @all_challenges.where(status_cd: 'draft')
                        else
                          @all_challenges
                  end
    @challenges = if current_participant&.admin?
                    @challenges.page(params[:page]).per(20)
                  else
                    @challenges.where(hidden_challenge: false).page(params[:page]).per(20)
                  end
  end

  def reorder
    authorize Challenge
    @challenges = policy_scope(Challenge)
  end

  def assign_order
    authorize Challenge
    @final_order = params[:order].split(',')
    @final_order.each_with_index do |ch, idx|
      Challenge.friendly.find(ch).update(featured_sequence: idx)
    end

    redirect_to reorder_challenges_path
  end

  def show
    if current_participant
      @challenge_participant = @challenge.challenge_participants.where(
        participant_id:                   current_participant.id,
        challenge_rules_accepted_version: @challenge.current_challenge_rules_version)
    end

    @challenge.record_page_view unless params[:version] # dont' record page views on history pages
    @challenge_rules = @challenge.current_challenge_rules
  end

  def new
    @challenge = @organizer.challenges.new
    authorize @challenge
  end

  def edit; end

  def create
    @challenge                = @organizer.challenges.new(challenge_params)
    @challenge.clef_challenge = true if @organizer.clef_organizer
    authorize @challenge

    if @challenge.save
      redirect_to edit_organizer_challenge_path(@organizer, @challenge), notice: 'Challenge created.'
    else
      render :new
    end
  end

  def update
    if @challenge.update(challenge_params)
      redirect_to [@organizer, @challenge],
                  notice: 'Challenge updated.'
    else
      render :edit
    end
  end

  def destroy
    @challenge.destroy
    redirect_to challenges_url,
                notice: 'Challenge was deleted.'
  end

  def clef_task
    @challenge = Challenge.friendly.find(params[:challenge_id])
    authorize @challenge
    @clef_task = @challenge.clef_task
  end

  def regrade
    challenge = Challenge.friendly.find(params[:challenge_id])
    authorize challenge
    challenge.submissions.each do |s|
      # SubmissionGraderJob.perform_later(s.id)
    end
    @submission_count = challenge.submissions_count
    render 'challenges/form/regrade_status'
  end

  def remove_image
    @challenge = Challenge.friendly.find(params[:challenge_id])
    authorize @challenge
    @challenge.remove_image_file!
    @challenge.save
    redirect_to edit_organizer_challenge_path(@challenge.organizer, @challenge), notice: 'Image removed.'
  end

  private

  def set_challenge
    @challenge = Challenge.friendly.find(params[:id])
    if params[:version]
      @challenge = @challenge
                       .versions[params[:version].to_i].reify
    end
    authorize @challenge
  end

  def challenge_params
    params
        .require(:challenge)
        .permit(
          :id,
          :discourse_category_id,
          :organizer_id,
          :challenge,
          :tagline,
          :status,
          :description,
          :featured_sequence,
          :evaluation_markdown,
          :evaluation_criteria,
          :rules,
          :prizes,
          :prize_travel,
          :prize_cash,
          :prize_academic,
          :prize_misc,
          :resources,
          :submission_instructions,
          :primary_sort_order,
          :secondary_sort_order,
          :score_title,
          :score_secondary_title,
          :other_scores_fieldnames,
          :teams_allowed,
          :hidden_challenge,
          :max_team_participants,
          :team_freeze_time,
          :latest_submission,
          :description_markdown,
          :rules_markdown,
          :prizes_markdown,
          :resources_markdown,
          :dataset_description_markdown,
          :submission_instructions_markdown,
          :license,
          :license_markdown,
          :winner_description_markdown,
          :winners_tab_active,
          :perpetual_challenge,
          :automatic_grading,
          :answer_file_s3_key,
          :submission_license,
          :api_required,
          :daily_submissions,
          :threshold,
          :online_grading,
          :start_dttm,
          :end_dttm,
          :media_on_leaderboard,
          :challenge_client_name,
          :image_file,
          :dynamic_content_url,
          :dynamic_content_flag,
          :dynamic_content_tab,
          :dynamic_content,
          :clef_task_id,
          :submissions_page,
          :private_challenge,
          :show_leaderboard,
          :ranking_window,
          :ranking_highlight,
          :grader_identifier,
          :online_submissions,
          :grader_logs,
          :grading_history,
          :post_challenge_submissions,
          :submissions_downloadable,
          :dataset_note_markdown,
          :discussions_visible,
          :require_toc_acceptance,
          :toc_acceptance_text,
          :toc_acceptance_instructions_markdown,
          :toc_accordion,
          dataset_attributes:                     [
            :id,
            :challenge_id,
            :description,
            :_destroy
          ],
          submissions_attributes:                 [
            :id,
            :challenge_id,
            :participant_id,
            :_destroy
          ],
          image_attributes:                       [
            :id,
            :image,
            :_destroy
          ],
          submission_file_definitions_attributes: [
            :id,
            :challenge_id,
            :seq,
            :submission_file_description,
            :filetype,
            :file_required,
            :submission_file_help_text,
            :_destroy
          ],
          challenge_rounds_attributes:            [
            :id,
            :challenge_round,
            :seq,
            :start_dttm,
            :end_dttm,
            :active,
            :minimum_score,
            :minimum_score_secondary,
            :submission_limit,
            :submission_limit_period,
            :failed_submissions,
            :ranking_window,
            :ranking_highlight,
            :score_significant_digits,
            :score_secondary_significant_digits,
            :leaderboard_note_markdown,
            :parallel_submissions,
            :_destroy
          ],
          challenge_partners_attributes:          [
            :id,
            :image_file,
            :partner_url,
            :_destroy
          ],
          challenge_rules_attributes:             [
            :id,
            :terms_markdown,
            :has_additional_checkbox,
            :additional_checkbox_text_markdown
          ],
          invitations_attributes:                 [
            :id,
            :email,
            :_destroy
          ])
  end

  def set_organizer
    @organizer = Organizer.friendly.find(params[:organizer_id])
  end

  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET
                          .presigned_post(
                            key:                   "answer_files/#{@challenge.slug}_#{SecureRandom.uuid}/${filename}",
                            success_action_status: '201',
                            acl:                   'private')
  end
end
