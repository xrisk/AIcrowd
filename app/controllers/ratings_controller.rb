class RatingsController < ApplicationController

  def index
  end

  def create
    ratings = Rating.create!(rating_params["_json"])
    cle = ratings.first.challenge_leaderboard_extra
    if cle.use_for_final_rating?
      cle.rating_calculated = true
    end
    cle.rating_last_calculated_at = DateTime.now
    cle.save!
    Reputation::CalculateGlobalRankService(ratings)

    # Now send notifications - Challenge end notification
    #
  end

  private

  def rating_params
    params.permit!
  end


end