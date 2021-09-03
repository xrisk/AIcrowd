class LeaderboardsController < ApplicationController
  before_action :authenticate_participant!, except: [:index, :get_affiliation]
  before_action :set_challenge, only: [:index, :export, :destroy, :get_affiliation]
  before_action :set_current_round, only: [:index, :export, :get_affiliation]
  before_action :set_current_leaderboard, only: [:index, :export, :get_affiliation]
  before_action :set_leaderboards, only: [:index, :get_affiliation]
  before_action :set_filter_service, only: [:index, :get_affiliation]

  respond_to :js, :html

  def index
    unless @leaderboards.first&.disentanglement?
      preloader = ActiveRecord::Associations::Preloader.new
      preloader.preload(@leaderboards.select { |p| p.submitter_type == 'Participant' }, :submitter)
      preloader.preload(@leaderboards.select { |p| p.submitter_type == 'Team' }, :submitter)

      @submitter_submissions = {}
      @leaderboards.each do |leaderboard|
        next if leaderboard.submitter_id.blank?

        if leaderboard.submitter.present?
          @submitter_submissions.merge!("submitter#{leaderboard.submitter.id}_submissions_by_day": submitter_submissions(leaderboard.submitter))
        end
      end
    end
    @top_three_winners = @leaderboards.where(baseline: false).first(3)

    if params[:country_name].present? || params[:affiliation].present?
      @leaderboards = @leaderboards.where(id: @filter.call('leaderboard_ids'))
      @leaderboards = paginate_leaderboards_by(:seq)
    else
      @leaderboards     = if @leaderboards.first&.disentanglement?
                            paginate_leaderboards_by(:row_num)
                          else
                            paginate_leaderboards_by(:seq)
                          end
    end

    @vote             = @challenge.votes.find_by(participant_id: current_participant.id) if current_participant.present?
    @follow           = @challenge.follows.find_by(participant_id: current_participant.id) if current_participant.present?
    @challenge_rounds = @challenge.challenge_rounds.started
    @post_challenge   = post_challenge?
    @following        = following?
    @leaderboards     = @leaderboards.includes(:challenge, :submission, :team, :participant)
    @leaderboard_participants = {}
    @leaderboard_challenges = {}
    @leaderboards.each do |leaderboard|
      @leaderboard_participants[leaderboard.id] = helpers.leaderboard_participants(leaderboard)
    end

    unless @leaderboards.first&.disentanglement?
      @countries = @filter.call('participant_countries')
      @affiliations = @filter.call('participant_affiliations')
    end
  end

  def export
    authorize @challenge, :export?

    leaderboard_class = freeze_record_for_organizer ? 'OngoingLeaderboard' : 'Leaderboard'

    @leaderboards = leaderboard_class.constantize
      .where(challenge_round_id: params[:leaderboard_export_challenge_round_id].to_i)
      .order(:seq)

    csv_data = Leaderboards::CSVExportService.new(leaderboards: @leaderboards).call.value

    send_data csv_data,
              type:     'text/csv',
              filename: "#{@challenge.challenge.to_s.parameterize.underscore}_leaderboard_export.csv"
  end

  def get_affiliation
    @affiliations = @filter.call('participant_affiliations')
  end

  def recalculate_leaderboard
    authorize Leaderboard
    leaderboard = ChallengeLeaderboardExtra.find_by_id(params[:leaderboard_id])
    challenge_round_id = leaderboard&.challenge_round_id
    CalculateLeaderboardJob.perform_later(challenge_round_id: challenge_round_id)
    redirect_to challenge_leaderboards_path, notice: "Leaderboard recalculation is in progress."
  end

  def destroy
    leaderboard = ChallengeLeaderboardExtra.find_by_id(params[:id])
    if !leaderboard.default
      leaderboard.destroy!
      redirect_to helpers.edit_challenge_path(@challenge), notice: "Leaderboard deleted successfully!"
    else
      redirect_to helpers.edit_challenge_path(@challenge), notice: "Can't delete default leaderboard"
    end
  end

  private

  def set_challenge
    @challenge = Challenge.friendly.find(params[:challenge_id])
    challenge_type = params['ml_challenge_id'].present? ? 'ml_challenge_id' : 'meta_challenge_id'

    if params.has_key?(challenge_type) and params[challenge_type.to_sym] != params[:challenge_id]
      if params['ml_challenge_id'].present?
        @ml_challenge = Challenge.includes(:organizers).friendly.find(params[challenge_type.
          to_sym])
      else
        @meta_challenge = Challenge.includes(:organizers).friendly.find(params[challenge_type.
          to_sym])
      end
    elsif @challenge.meta_challenge
      params[challenge_type.to_sym] = params[:challenge_id]
    elsif @challenge.ml_challenge
      params[challenge_type.to_sym] = params[:challenge_id]
    end

    if !params.has_key?(challenge_type)
      cps = ChallengeProblems.where(problem_id: @challenge.id)
      cps.each do |cp|
        if cp.exclusive? && params[:action] != 'get_affiliation'
          params[challenge_type.to_sym] = Challenge.find(cp.challenge_id).slug
          redirect_to helpers.challenge_leaderboards_path(@challenge) and return
        end
      end
    end
  end

  def set_current_round
    @current_round = if params[:challenge_round_id].present?
      @challenge.challenge_rounds.find(params[:challenge_round_id].to_i)
    else
      @challenge.active_round
    end
    redirect_to @challenge, notice: "Round hasn't started for this challenge" if @current_round.blank?
  end

  def set_current_leaderboard
    @current_leaderboard = if params[:challenge_leaderboard_extra_id].present?
      @current_round.challenge_leaderboard_extras.find(params[:challenge_leaderboard_extra_id].to_i)
    else
      @current_round.default_leaderboard
    end

    @current_user_view_all = false
    if current_participant.present?
      if (policy(@challenge).edit? || current_participant&.admin)
        @current_user_view_all = true
      end
    end
  end

  def post_challenge?
    @challenge.completed? && params[:post_challenge] == "true" && !@challenge.meta_challenge?
  end

  def following?
    params[:following] == 'true'
  end

  def set_leaderboards
    # Backward compactibility for multiple leaderboards change
    # Old challenges can continue to show their single leaderboard (without id)
    leaderboard_ids = [@current_leaderboard&.id]
    if !@current_leaderboard.present? || @current_leaderboard.id == @current_round.default_leaderboard.id
      leaderboard_ids.push(nil)
    end

    filter = { challenge_round_id: @current_round&.id.to_i, meta_challenge_id: nil, challenge_leaderboard_extra_id: leaderboard_ids }

    if @meta_challenge.present?
      filter[:meta_challenge_id] = @meta_challenge.id
    elsif @ml_challenge.present?
      filter[:ml_challenge_id] = @ml_challenge.id
    end
    @leaderboards = if @challenge.challenge == "NeurIPS 2019 : Disentanglement Challenge"
      BaseLeaderboard
        .where(challenge_round_id: @current_round)
        .freeze_record(current_participant, @current_leaderboard)
    elsif post_challenge? || freeze_record_for_organizer
      policy_scope(OngoingLeaderboard)
        .where(filter)
    elsif @challenge.ml_challenge? && current_participant.nil?
      Leaderboard.none
    else
      if helpers.cache_enabled?
        Rails.cache.fetch("leaderboard-#{filter.to_s}") do
          policy_scope(Leaderboard)
            .where(filter)
        end
      else
        policy_scope(Leaderboard)
            .where(filter)
      end
    end

    if following? && current_participant.present?
      following_ids = current_participant.following.pluck(:followable_id)
      @leaderboards = @leaderboards.where(submitter_id: following_ids)
      @following    = true
    end
  end

  def paginate_leaderboards_by(order)
    nextpage = @leaderboards.per_page_kaminari(params[:page]).per(50).order(order)

    if current_participant.present?

      team_id = get_team_id(@challenge, @current_participant.id)

      if team_id.present?
        @self_standing    = @leaderboards.where(submitter_id: team_id, submitter_type: 'Team')
      else
        @self_standing    = @leaderboards.where(submitter_id: @current_participant.id, submitter_type: 'Participant')
      end

      if @self_standing.present? && nextpage.present?
          nextpage.each do |row|
            if @self_standing.ids.include? row.id
              @self_standing = nil
              break
            end
          end
      end
    end

    nextpage
  end

  def set_filter_service
    @filter = Leaderboards::FilterService.new(leaderboards: @leaderboards, params: params)
  end

  def submitter_submissions(submitter)
    Rails.cache.fetch("submitter-submissions-#{@challenge.id}-#{submitter.id}-#{submitter.class}") do
      submissions = @challenge.meta_challenge? ? submitter.meta_challenge_submissions(@challenge) : submitter.challenge_submissions(@challenge)
      submissions.group_by_created_at
    end
  end

  def freeze_record_for_organizer
    return false unless @current_leaderboard&.freeze_flag

    (policy(@challenge).edit? || current_participant&.admin)
  end

  def get_team_id(challenge, participant_id)
    team = challenge.teams.joins(:team_participants).find_by(team_participants: { participant_id: participant_id})

    if team.present?
      team.id
    else
      nil
    end
  end


end
