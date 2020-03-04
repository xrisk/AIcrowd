class InsightsController < ApplicationController
  before_action :set_challenge
  before_action :set_challenge_rounds, only: :index
  before_action :set_vote, only: :index
  before_action :set_follow, only: :index
  before_action :set_current_round, except: :challenge_participants_country
  before_action :set_collection, except: [:index, :challenge_participants_country]

  def index
  end

  def submissions_vs_time
    render json: @collection.group_by_day(:created_at).count
  end

  def top_score_vs_time
    # Calculate running maximum hash for dates

    score              = params[:score].presence || 'score'
    precision          = @challenge.active_round["#{score}_precision"]
    sort_order         = if score == 'score'
                           @current_round["primary_sort_order_cd"]
                         else
                           @current_round["secondary_sort_order_cd"]
                         end

    grouped_collection = @collection.group_by_day(:created_at)

    return_hash = if sort_order == "descending"
                    get_running_agg('min', grouped_collection.maximum(:score), precision)
                  else
                    # sort_order == "ascending" or "not_used"
                    get_running_agg('max', grouped_collection.minimum(:score), precision)
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
    ret       = {}
    current   = 0
    current   = Float::INFINITY if fn == 'min'
    grouped_collection.each do |key, value|
      current  = [current, value.to_f.round(precision)].method(fn).call
      ret[key] = current
    end
    ret
  end

  def set_challenge
    @challenge = Challenge.friendly.find(params[:challenge_id])
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
end
