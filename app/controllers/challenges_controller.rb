class ChallengesController < ApplicationController
  before_action :authenticate_participant!, except: [:show, :index]
  before_action :terminate_challenge, only: [:show, :index]
  before_action :set_challenge, only: [:show, :edit, :update, :clef_task, :remove_image, :remove_banner, :export, :import, :remove_invited, :remove_social_media_image]
  before_action :set_vote, only: [:show, :clef_task]
  before_action :set_follow, only: [:show, :clef_task]
  after_action :verify_authorized, except: [:index, :show]
  before_action :set_s3_direct_post, only: [:edit, :update]
  before_action :set_challenge_rounds, only: [:edit, :update]
  before_action :set_filters, only: [:index]
  before_action :set_organizers_for_select, only: [:new, :create, :edit, :update]

  respond_to :html, :js

  def index
    @challenge_filter = params[:challenge_filter] ||= 'all'
    @all_challenges   = policy_scope(Challenge).not_practice
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
    @challenges       = Challenges::FilterService.new(params, @challenges).call
    @challenges       = if current_participant&.admin?
                          @challenges.page(params[:page]).per(18)
                        else
                          @challenges.where(hidden_challenge: false).page(params[:page]).per(18)
                        end
  end

  def show
    if current_participant
      @challenge_participant = @challenge.challenge_participants.where(
        participant_id:                   current_participant.id,
        challenge_rules_accepted_version: @challenge.current_challenge_rules&.version)
    end

    @challenge.record_page_view(@meta_challenge) unless params[:version] # dont' record page views on history pages
    @challenge_rules  = @challenge.current_challenge_rules
    @challenge_rounds = @challenge.challenge_rounds.started
    @partners = Partner.where(organizer_id: @challenge.organizer_ids) if @challenge.organizers.any?
    @challenge_baseline_discussion = @challenge.baseline_discussion
    if @challenge.active_round
      @top_five_leaderboards = @challenge.active_round.leaderboards.where(meta_challenge_id: @meta_challenge, baseline: false, challenge_leaderboard_extra_id: nil).limit(5)
      @latest_five_submissions = @challenge.active_round.submissions.where(meta_challenge_id: @meta_challenge).order(created_at: :desc).limit(5)
    end

    if @challenge.meta_challenge
      @latest_five_submissions = Submission.where(meta_challenge_id: @challenge).order(created_at: :desc).limit(5)
      params[:meta_challenge_id] = params[:id]
      render template: "challenges/show_meta_challenge"
    end

    if @challenge.ml_challenge
      params[:ml_challenge_id] = params[:id]
      @date_wise_challenge     = get_date_wise_challenge_problem
      render template: "challenges/show_ml_challenge"
    end
  end

  def new
    @organizer = Organizer.find_by(id: params[:organizer_id])
    @challenge = Challenge.new
    @challenge.organizers << @organizer if @organizer.present?

    authorize @challenge
  end

  def create
    @challenge                = Challenge.new(challenge_params)
    @challenge.organizers     = current_participant.organizers if current_participant&.admin? == false
    @challenge.clef_challenge = true if @challenge.organizers.any?(&:clef_organizer?)

    authorize @challenge

    if @challenge.save
      update_challenges_organizers if params[:challenge][:organizer_ids].present?
      update_challenge_categories if params[:challenge][:category_names].present?
      redirect_to helpers.edit_challenge_path(@challenge, step: :overview), notice: 'Challenge created.'
    else
      flash[:error] = @challenge.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @example_leaderboards = []
    for rank in 1..4
      if Participant.count < 10
        break
      end
      @example_leaderboards.append(
        Leaderboard.new(
          row_num: rank,
          score: 9/rank,
          score_secondary: 3/rank,
          submitter_type: 'Participant',
          submitter_id: Participant.all.sample(10)[rank].id,
          participant: Participant.all.sample(10)[rank],
          challenge_id: @challenge.id,
          created_at: Time.new,
          entries: 10
        )
      )
    end
  end

  def update_challenge_leaderboard_extras
    filters = params[:challenge][:challenge_extra_leaderboard_filters].split(',').reject { |c| c.empty? }
    names = params[:challenge][:challenge_extra_leaderboard_names].split(',').reject { |c| c.empty? }
    if filters.length != names.length
      @challenge.errors.messages.merge!('Invalid configuration provided for extra leaderboards.')
      return
    end

    @challenge.challenge_leaderboard_extras.each do |leaderboard|
      if !filters.include?(leaderboard.filter)
        leaderboard.destroy
      end
    end

    for i in (0..names.length-1) do
      leaderboard = ChallengeLeaderboardExtra.where(challenge_id: @challenge.id, filter: filters[i]).first_or_initialize
      leaderboard.name = names[i]
      leaderboard.save!
    end

    leaderboard_recomputations
  end

  def update
    update_challenge_leaderboard_extras if params[:challenge][:challenge_extra_leaderboard_names].present?
    if @challenge.update(challenge_params)
      update_challenges_organizers if params[:challenge][:organizer_ids].present?
      update_challenge_categories if params[:challenge][:category_names].present?
      create_invitations if params[:challenge][:invitation_email].present?
      leaderboard_recomputations
      respond_to do |format|
        format.html { redirect_to helpers.edit_challenge_path(@challenge, step: params[:current_step]), notice: 'Challenge updated.' }
        format.js   { render :update }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js   { render :update }
      end
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
      Challenge.friendly.find(ch).update(featured_sequence: idx+1)
    end

    redirect_to helpers.reorder_challenges_path
  end

  def clef_task
    @clef_task        = @challenge.clef_task
    @challenge_rounds = @challenge.challenge_rounds.started
  end

  def remove_image
    @challenge.remove_image_file!
    @challenge.save

    respond_to do |format|
      format.js { render :remove_image }
    end
  end

  def remove_social_media_image
    @challenge.remove_social_media_image_file!
    @challenge.save

    respond_to do |format|
      format.js { render :remove_image }
    end
  end

  def remove_banner
    @challenge.remove_banner_file!
    @challenge.save

    respond_to do |format|
      format.js { render :remove_image }
    end
  end

  def remove_banner_mobile
    @challenge.remove_banner_mobile_file!
    @challenge.save

    respond_to do |format|
      format.js { render :remove_image }
    end
  end

  def export
    challenge_json = Export::ChallengeSerializer.new(@challenge).as_json.to_json

    send_data challenge_json,
              type:     'application/json',
              filename: "#{@challenge.challenge.to_s.parameterize.underscore}_export.json"
  end

  def import
    result = Challenges::ImportService.new(import_file: params[:import_file], organizers: @challenge.organizers).call

    if result.success?
      redirect_to helpers.edit_challenge_path(@challenge, step: :admin), notice: 'New Challenge Imported'
    else
      redirect_to helpers.edit_challenge_path(@challenge, step: :admin), flash: { error: result.value }
    end
  end

  def remove_invited
    challenge_invitation = @challenge.invitations.find(params[:invited_id])
    challenge_invitation.destroy!
  end

  private

  def set_challenge
    @challenge = Challenge.includes(:organizers).friendly.find(params[:id])
    @challenge = @challenge.versions[params[:version].to_i].reify if params[:version]
    authorize @challenge

    if params.has_key?('meta_challenge_id')
      @meta_challenge = Challenge.includes(:organizers).friendly.find(params[:meta_challenge_id])
      if !@meta_challenge.meta_challenge || !@meta_challenge.problems.include?(@challenge)
        raise ActionController::RoutingError.new('Not Found')
      end
    end

    if params.has_key?('ml_challenge_id')
      @ml_challenge = Challenge.includes(:organizers).friendly.find(params[:ml_challenge_id])
      if !@ml_challenge.ml_challenge || !@ml_challenge.problems.include?(@challenge)
        raise ActionController::RoutingError.new('Not Found')
      end
    end

    if !params.has_key?('meta_challenge_id') && !params.has_key?('ml_challenge_id')
      cps = ChallengeProblems.where(problem_id: @challenge.id)
      cps.each do |cp|
        if cp.exclusive?
          challenge_type_id                = "#{cp.challenge.challenge_type}_id"
          params[challenge_type_id.to_sym] = Challenge.find(cp.challenge_id).slug
          redirect_to helpers.challenge_path(@challenge) and return
        end
      end
    end
  end

  def set_vote
    @vote = @challenge.votes.where(participant_id: current_participant.id).first if current_participant.present?
  end

  def set_follow
    @follow = @challenge.follows.where(participant_id: current_participant.id).first if current_participant.present?
  end

  def set_organizers_for_select
    # We'll need refactor to select2 with API endpoint when we'll have a lot of organizers.
    @organizers_for_select = Organizer.pluck(:organizer, :id)
  end

  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET
                          .presigned_post(
                            key:                   "answer_files/#{@challenge.slug}_#{SecureRandom.uuid}/${filename}",
                            success_action_status: '201',
                            acl:                   'private')
  end

  def set_challenge_rounds
    @challenge_rounds = @challenge.challenge_rounds.where("start_dttm < ?", Time.current)
  end

  def set_filters
    @categories = Category.all
    @status     = challenge_status
    @prize_hash = { prize_cash:     'Cash prizes',
                    prize_travel:   'Travel grants',
                    prize_academic: 'Academic papers',
                    prize_misc:     'Misc prizes' }
  end

  def challenge_status
    params[:controller] == "landing_page" ? Challenge.statuses.keys - ['draft'] : Challenge.statuses.keys
  end

  def create_invitations
    params[:challenge][:invitation_email].split(',').each do |email|
      @challenge.invitations.create!(email: email.strip)
    end
  end

  def leaderboard_recomputations
    @challenge.challenge_rounds.pluck(:id).each do |round_id|
      CalculateLeaderboardJob.perform_later(challenge_round_id: round_id)
    end
  end

  def update_challenges_organizers
    @challenge.challenges_organizers.destroy_all
    params[:challenge][:organizer_ids].each do |organizer_id|
      @challenge.challenges_organizers.create(organizer_id: organizer_id)
    end
  end

  def update_challenge_categories
    @challenge.category_challenges.destroy_all if @challenge.category_challenges.present?
    params[:challenge][:category_names].reject(&:empty?).each do |category_name|
      category = Category.find_or_create_by(name: category_name)
      if category.save
        @challenge.category_challenges.create!(category_id: category.id)
      else
        @challenge.errors.messages.merge!(category.errors.messages)
      end
    end
  end

  def get_date_wise_challenge_problem
    return @challenge.problems if current_participant&.admin? && policy(@challenge).edit?
    return @challenge.problems unless current_participant.present?

    challenge_participant = current_participant.challenge_participants.where(challenge: @challenge).first

    return @challenge.problems unless challenge_participant.present?

    day_num               = (Time.now.to_date - challenge_participant.challenge_rules_accepted_date.to_date).to_i + 1
    problem_ids           = @challenge.challenge_problems.where("occur_day <= ?", day_num).pluck(:problem_id)

    @challenge.problems.where(id: problem_ids)
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
      :social_media_image_file,
      :challenge_client_name,
      :grader_identifier,
      :other_scores_fieldname,
      :discourse_category_id,
      :other_scores_fieldnames,
      :description,
      :prize_cash,
      :prize_travel,
      :prize_academic,
      :prize_misc,
      :private_challenge,
      :clef_task_id,
      :online_submissions,
      :evaluator_type_cd,
      :post_challenge_submissions,
      :submission_instructions,
      :license,
      :winners_tab_active,
      :winner_description,
      :submissions_downloadable,
      :dynamic_content_flag,
      :dynamic_content_tab,
      :dynamic_content,
      :dynamic_content_url,
      :scrollable_overview_tabs,
      :meta_challenge,
      :banner_file,
      :banner_mobile_file,
      :banner_color,
      :big_challenge_card_image,
      :practice_flag,
      :ml_challenge,
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
        :score_title,
        :score_secondary_title,
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
        :leaderboard_note,
        :primary_sort_order,
        :secondary_sort_order,
        :freeze_flag,
        :freeze_duration,
        :submissions_type,
        :debug_submission_limit,
        :debug_submission_limit_period,
        :media_on_leaderboard,
        :show_leaderboard,
        :other_scores_fieldnames
      ],
      challenge_rules_attributes: [
        :id,
        :terms,
        :has_additional_checkbox,
        :additional_checkbox_text
      ]
    )
  end
end
