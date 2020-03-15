class RatingLeaderboardController < ApplicationController
  def index
    # Top participants by ranking
    if params[:page].to_i < 6
      @top_participants = Participant.where("ranking > 0").reorder(:ranking).page(params[:page]).per(20)
    else
      @top_participants = nil
    @participants = @top_participants
    if @current_participant.present? and @current_participant.ranking.present?
      @self_standing = Participant.where("ranking < #{@current_participant.attributes['ranking'] + 3} and ranking > #{@current_participant.attributes['ranking'] - 3}").reorder('ranking asc').limit(6)
    end
  end
end
