class ChallengesController < ApplicationController
  before_action :authenticate_participant!, except: [:show, :index]
  before_action :terminate_challenge, only: [:show, :index]
  before_action :set_challenge, only: [:show, :edit, :update, :destroy, :clef_task, :remove_image, :export, :import, :remove_invited]
  before_action :set_vote, only: [:show, :clef_task]
  before_action :set_follow, only: [:show, :clef_task]
  after_action :verify_authorized, except: [:index, :show]
  before_action :set_s3_direct_post, only: [:edit, :update]
  before_action :set_challenge_rounds, only: [:edit, :update]
  before_action :set_filters, only: [:index]
  before_action :set_organizers_for_select, only: [:new, :create, :edit, :update]
  before_action :set_categories_for_select, only: [:new, :create, :edit, :update]

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

    @challenge.record_page_view unless params[:version] # dont' record page views on history pages
    @challenge_rules  = @challenge.current_challenge_rules
    @challenge_rounds = @challenge.challenge_rounds.started
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
      update_challenge_categories if params[:challenge][:category_ids].present?
      redirect_to edit_challenge_path(@challenge, step: :overview), notice: 'Challenge created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @challenge.update(challenge_params)
      update_challenges_organizers if params[:challenge][:organizer_ids].present?
      update_challenge_categories if params[:challenge][:category_ids].present?
      set_challenge
      create_invitations if params[:challenge][:invitation_email].present?
      respond_to do |format|
        format.html { redirect_to edit_challenge_path(@challenge, step: params[:current_step]), notice: 'Challenge updated.' }
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
      Challenge.friendly.find(ch).update(featured_sequence: idx)
    end

    redirect_to reorder_challenges_path
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

  def export
    challenge_json = Export::ChallengeSerializer.new(@challenge).as_json.to_json

    send_data challenge_json,
              type:     'application/json',
              filename: "#{@challenge.challenge.to_s.parameterize.underscore}_export.json"
  end

  def import
    result = Challenges::ImportService.new(import_file: params[:import_file], organizers: @challenge.organizers).call

    if result.success?
      redirect_to edit_challenge_path(@challenge, step: :admin), notice: 'New Challenge Imported'
    else
      redirect_to edit_challenge_path(@challenge, step: :admin), flash: { error: result.value }
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
  end

  def set_vote
    @vote = @challenge.votes.where(participant_id: current_participant.id).first if current_participant.present?
  end

  def set_follow
    @follow = @challenge.follows.where(participant_id: current_participant.id).first if current_participant.present?
  end

  def set_categories_for_select
    @categories_for_select = Category.pluck(:name, :id)
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

  def update_challenges_organizers
    @challenge.challenges_organizers.destroy_all
    params[:challenge][:organizer_ids].each do |organizer_id|
      @challenge.challenges_organizers.create(organizer_id: organizer_id)
    end
  end

  def update_challenge_categories
    @challenge.category_challenges.destroy_all
    params[:challenge][:category_ids].each do |category_id|
      @challenge.category_challenges.create(category_id: category_id)
    end
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
        :_destroy
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
