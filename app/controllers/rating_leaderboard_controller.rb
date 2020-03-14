class RatingLeaderboardController < ApplicationController
  def index
    rating_query = ParticipantRatingRanksQuery.new
    @count = rating_query.participants_count
    if params[:page].to_i < 10
      @participants = rating_query.participants_with_ranks.page(params[:page]).per(10)
      @user_position_participants = rating_query.user_position_participants(current_participant)
    else
      @participants = nil
      @user_position_participants = nil
    end
  end
end
