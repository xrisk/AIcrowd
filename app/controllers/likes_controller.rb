class LikesController < ApplicationController

  def create
    Post.friendly.find(params[:post_id]).likes.create!(participant_id: current_participant.id)
  end

end
