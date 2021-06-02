class RatingsController < ApplicationController

  def index
    @rank_1 = GlobalRank.order('rating desc').first
    @rank_2 = GlobalRank.order('rating desc').second
    @rank_3 = GlobalRank.order('rating desc').third

    @rankings = GlobalRank.order('rating desc').includes(:participant).offset(3).limit(100)
    get_topper_graph_data
  end

  def create
    ratings = Rating.create!(rating_params["_json"])
    cle = ratings.first.challenge_leaderboard_extra
    if cle.use_for_final_rating?
      cle.rating_calculated = true
    end
    cle.rank_last_calculated_at = DateTime.now
    cle.save!
    Reputation::CalculateGlobalRankService.new(ratings).call

    # Now send notifications - Challenge end notification
    #
  end

  private

  def rating_params
    params.permit!
  end

  def get_topper_graph_data
    @rank_1_graph = {}
    @rank_2_graph = {}
    @rank_3_graph = {}
    @rank_1.participant.ratings.each do |rating|
      @rank_1_graph[rating.created_at.to_date] = rating.rating
    end
    @rank_2.participant.ratings.each do |rating|
      @rank_2_graph[rating.created_at.to_date] = rating.rating
    end
    @rank_3.participant.ratings.each do |rating|
      @rank_3_graph[rating.created_at.to_date] = rating.rating
    end
  end


end