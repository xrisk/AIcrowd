class InsightsController < ApplicationController
  before_action :set_challenge
  before_action :set_challenge_rounds, only: :index
  before_action :set_vote, only: :index
  before_action :set_follow, only: :index
  before_action :set_current_round, except: :challenge_participants_country
  before_action :set_collection, except: [:index, :challenge_participants_country]

  def index
    if current_participant&.ml_activity_points.present?
      @gained_points = current_participant.ml_activity_points.sum_points
      challenge_id   = @ml_challenge.present? ? @ml_challenge.id : @challenge.id
      @goal_points   = current_participant.participant_ml_challenge_goals.find_by(challenge_id: challenge_id)&.daily_practice_goal&.points
      @streak_record = get_streak_record if @goal_points.present?
    end
  end

  def submissions_vs_time
    render json: @collection.group_by_day(:created_at).count
  end

  def top_score_vs_time
    return render json: {} if @current_round.blank?

    # Calculate running maximum hash for dates

    score              = params[:score].presence || 'score'
    precision          = @current_round["#{score}_precision"]

    sort_order         = if score == 'score'
                           @current_round['primary_sort_order_cd']
                         else
                           @current_round['secondary_sort_order_cd']
                         end

    grouped_collection = @collection.group_by_day(:created_at)

    return_hash = if sort_order == 'descending'
                    get_running_agg('max', grouped_collection.maximum(score), precision)
                  else
                    # sort_order == "ascending" or "not_used"
                    get_running_agg('min', grouped_collection.minimum(score), precision)
                  end

    render json: return_hash
  end

  def challenge_participants_country
    country_count = Hash.new(0)
    @challenge.participants.each do |participant|
      country                 = ISO3166::Country[participant.country_cd]&.name
      country               ||= participant.visits.where.not(country: nil).last&.country
      country_count[country] += 1
    end

    render json: country_count.except(nil)
  end

  private

  def get_running_agg(fn, grouped_collection, precision)
    ret     = {}
    current = 0
    current = Float::INFINITY if fn == 'min'

    grouped_collection.each do |key, value|
      next if value.nil?

      current  = [current, value.to_f.round(precision)].method(fn).call
      ret[key] = current
    end
    ret
  end

  def set_challenge
    @challenge = Challenge.friendly.find(params[:challenge_id])
    if params.has_key?('meta_challenge_id')
      @meta_challenge = Challenge.friendly.find(params[:meta_challenge_id])
    elsif params.has_key?('ml_challenge_id')
      @ml_challenge = Challenge.friendly.find(params[:ml_challenge_id])
    elsif @challenge.challenge_type.present?
      challenge_type_id                = "#{@challenge.challenge_type}_id"
      params[challenge_type_id.to_sym] = params[:challenge_id]
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
                       @challenge.active_round
                     end
  end

  def set_collection
    @collection = @challenge.submissions
    @collection = @current_round.submissions if @current_round.present?
    if @challenge.meta_challenge?
      @collection = @challenge.submissions
    elsif @meta_challenge
      @collection = @collection.where(meta_challenge_id: @meta_challenge.id)
    end
  end

  def get_streak_record
    hash_record   = current_participant.ml_activity_points.group_by_day(:created_at, format: '%Y-%m-%d').sum_points_by_day
    @values       = hash_record.values
    @streak_array = []

    @values.each_with_index do |value, index|
      check_hit_goal_points(value, index, 0)
    end
    @streak_array.max || 0
  end

  def check_hit_goal_points(value, index, num)
    return if value.nil?

    if value > @goal_points
      num += 1
      @streak_array << num

      check_hit_goal_points(@values[index+ 1], index+ 1, num)
    end
  end
end
