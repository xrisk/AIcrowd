class LeaderboardsController < ApplicationController
  before_action :authenticate_participant!, except: [:index, :get_affiliation]
  before_action :set_challenge, only: [:index, :export, :get_affiliation]
  before_action :set_current_round, only: [:index, :export, :get_affiliation]
  before_action :set_current_extra_leaderboard, only: [:index, :export, :get_affiliation]
  before_action :set_leaderboards, only: [:index, :get_affiliation]
  before_action :set_filter_service, only: [:index, :get_affiliation]

  respond_to :js, :html

  def index
    unless @leaderboards.first&.disentanglement?
      @submitter_submissions = {}
      @leaderboards.each do |leaderboard|
        next if leaderboard.submitter.blank?

        @submitter_submissions.merge!("submitter#{leaderboard.submitter.id}_submissions_by_day": submitter_submissions(leaderboard.submitter).group_by_created_at)
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
  end

  def set_current_extra_leaderboard
    @current_challenge_leaderboard_extra = if params[:challenge_leaderboard_extra_id].present?
      @challenge.challenge_leaderboard_extras.find(params[:challenge_leaderboard_extra_id].to_i)
    else
      nil
    end
  end

  def post_challenge?
    @challenge.completed? && params[:post_challenge] == "true" && !@challenge.meta_challenge?
  end

  def following?
    params[:following] == 'true'
  end

  def set_leaderboards
    filter = { challenge_round_id: @current_round&.id.to_i, meta_challenge_id: nil, challenge_leaderboard_extra_id: @current_challenge_leaderboard_extra&.id }

    if @meta_challenge.present?
      filter[:meta_challenge_id] = @meta_challenge.id
    elsif @ml_challenge.present?
      filter[:ml_challenge_id] = @ml_challenge.id
    end
    @leaderboards = if @challenge.challenge == "NeurIPS 2019 : Disentanglement Challenge"
      BaseLeaderboard
        .where(challenge_round_id: @current_round)
        .freeze_record(current_participant)
    elsif post_challenge? || freeze_record_for_organizer
      policy_scope(OngoingLeaderboard)
        .where(filter)
    elsif @challenge.ml_challenge? && current_participant.nil?
      Leaderboard.none
    else
      policy_scope(Leaderboard)
        .where(filter)
    end

    if following?
      following_ids = current_participant.following.pluck(:followable_id)
      @leaderboards = @leaderboards.where(submitter_id: following_ids)
      @following    = true
    end
  end

  def paginate_leaderboards_by(order)
    @leaderboards.page(params[:page]).per(20).order(order)
  end

  def set_filter_service
    @filter = Leaderboards::FilterService.new(leaderboards: @leaderboards, params: params)
  end

  def submitter_submissions(submitter)
    @challenge.meta_challenge? ? submitter.meta_challenge_submissions(@challenge) : submitter.challenge_submissions(@challenge)
  end

  def freeze_record_for_organizer
    return false unless @current_round&.freeze_flag

    (policy(@challenge).edit? || current_participant&.admin)
  end
end
