class PostBookmarksController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_post
  respond_to :js

  def create
    PostBookmark.create!(post_id: params[:post_id], participant_id: current_participant.id)

    respond_to do |format|
      format.js { render :refresh }
    end
  end

  def destroy
    PostBookmark.where(id: params[:id]).first.destroy

    respond_to do |format|
      format.js { render :refresh }
    end
  end

  private

  def set_post
    @post = Post.find_by_id(params[:post_id])
  end
end
