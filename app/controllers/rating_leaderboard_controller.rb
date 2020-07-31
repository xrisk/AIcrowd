class RatingLeaderboardController < ApplicationController
  def index
    # Top participants by ranking
    @participants = Participant.where('ranking > 0').reorder(:ranking).page(params[:page]).per(20) if params[:page].to_i < 6
    if @current_participant.present? && @current_participant.ranking.present? && @current_participant.ranking != -1
      @self_standing = Participant.where(['ranking < ? and ranking > ?', (@current_participant.ranking + 3).to_s, [@current_participant.ranking - 3, 0].max.to_s]).reorder('ranking asc').limit(6)
    end
  end
end
