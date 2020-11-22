class LikesController < ApplicationController

  def create
    Post.find_by_id(params[:id]).likes.create!(participant_id: current_participant.id)
  end

  private

  # def like_params
  #   params.require(:like).permit(:id)
  # end
end