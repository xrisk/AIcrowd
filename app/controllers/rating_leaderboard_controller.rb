class RatingLeaderboardController < ApplicationController
  def index
    # Top participants by ranking
    if params[:page].to_i < 6
      @participants = Participant.where("ranking > 0").reorder(:ranking).per_page_kaminari(params[:page]).per(20)
    end
    if @current_participant.present? && @current_participant.ranking.present? && @current_participant.ranking != -1
      @self_standing = Participant.where(["ranking < ? and ranking > ?", "#{@current_participant.ranking + 3}", "#{[@current_participant.ranking - 3,0].max}"]).reorder('ranking asc').limit(6)
    end
  end
end
