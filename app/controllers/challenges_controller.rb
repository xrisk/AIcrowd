class ChallengesController < ApplicationController
  before_action :authenticate_participant!, except: [:show, :index]
  before_action :terminate_challenge, only: [:show, :index]
  before_action :set_challenge, only: [:show, :edit, :update, :destroy, :remove_image]
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
    @challenge = Challenge.new(organizer: @organizer)
    authorize @challenge
  end

  def create
    @challenge                = Challenge.new(challenge_params)
    @challenge.clef_challenge = true if @organizer&.clef_organizer
    authorize @challenge

    if @challenge.save
      redirect_to edit_challenge_path(@challenge, step: :overview), notice: 'Challenge created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @challenge.update(challenge_params)
      redirect_to edit_challenge_path(@challenge, step: params[:step]), notice: 'Challenge updated.'
    else
      render :edit
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

  def clef_task
    @challenge = Challenge.friendly.find(params[:challenge_id])
    authorize @challenge
    @clef_task = @challenge.clef_task
  end

  def remove_image
    @challenge.remove_image_file!
    @challenge.save
    redirect_to edit_challenge_path(@challenge), notice: 'Image removed.'
  end

  private

  def set_challenge
    @challenge = Challenge.includes(:organizer).friendly.find(params[:id])
    if params[:version]
      @challenge = @challenge
                       .versions[params[:version].to_i].reify
    end
    authorize @challenge
  end

  def set_organizer
    @organizer = @challenge&.organizer
  end

  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET
                          .presigned_post(
                            key:                   "answer_files/#{@challenge.slug}_#{SecureRandom.uuid}/${filename}",
                            success_action_status: '201',
                            acl:                   'private')
  end

  def challenge_params
    params.require(:challenge).permit(
      :challenge,
      :tagline,
      :require_registration,
      :show_leaderboard,
      :media_on_leaderboard,
      :submissions_page,
      :grading_history,
      :grader_logs,
      :discussions_visible,
      :latest_submission,
      :teams_allowed,
      :hidden_challenge,
      :max_team_participants,
      :team_freeze_time,
      :status,
      :featured_sequence,
      :image_file,
      :challenge_client_name,
      :grader_identifier,
      :score_title,
      :score_secondary_title,
      :primary_sort_order,
      :secondary_sort_order,
      :other_scores_fieldname,
      :organizer_id,
      :discourse_category_id,
      :other_scores_fieldnames,
      :description_markdown,
      :prize_cash,
      :prize_travel,
      :prize_academic,
      :prize_misc,
      :private_challenge,
      :clef_task_id,
      :online_submissions,
      :post_challenge_submissions,
      :submission_instructions_markdown,
      :license_markdown,
      :winners_tab_active,
      :winner_description_markdown,
      :submissions_downloadable,
      :dynamic_content_flag,
      :dynamic_content_tab,
      :dynamic_content,
      :dynamic_content_url,
      image_attributes: [
        :id,
        :image,
        :_destroy
      ],
      challenge_partners_attributes: [
        :id,
        :image_file,
        :partner_url,
        :_destroy
      ],
      challenge_rounds_attributes: [
        :id,
        :challenge_round,
        :minimum_score,
        :minimum_score_secondary,
        :submission_limit,
        :submission_limit_period,
        :failed_submissions,
        :parallel_submissions,
        :ranking_highlight,
        :ranking_window,
        :score_precision,
        :score_secondary_precision,
        :start_dttm,
        :end_dttm,
        :active,
        :leaderboard_note_markdown,
        :_destroy
      ],
      challenge_rules_attributes: [
        :id,
        :terms_markdown,
        :has_additional_checkbox,
        :additional_checkbox_text_markdown
      ],
      invitations_attributes: [
        :id,
        :email,
        :_destroy
      ]
    )
  end
end
