class RatingLeaderboardController < ApplicationController
  def index
    @participants = ParticipantRatingRanksQuery.new.participants_with_ranks.page(params[:page]).per(10)
  end
end
