class RatingLeaderboardController < ApplicationController
  def index
    # Top participants by ranking
    if params[:page].to_i < 6
      @participants = Participant.where("ranking > 0").reorder(:ranking).page(params[:page]).per(20)
    end
    if @current_participant.present? && @current_participant.ranking.present?
      @self_standing = Participant.where("ranking < #{@current_participant.ranking + 3} and ranking > #{@current_participant.ranking - 3}").reorder('ranking asc').limit(6)
    end
  end
end
