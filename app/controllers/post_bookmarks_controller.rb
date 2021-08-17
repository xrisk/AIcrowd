class PostBookmarksController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_post
  respond_to :js

  def create
    PostBookmark.create!(post_id: params[:post_id], participant_id: current_participant.id)
    @toast = true

    respond_to do |format|
      format.js { render :refresh }
    end
  end

  def destroy
    bookmark = PostBookmark.where(id: params[:id]).first
    @toast = false
    if bookmark.present? && bookmark.participant_id == current_participant.id
        bookmark.destroy
        @toast = true
    end

    respond_to do |format|
      format.js { render :refresh, toast: true, locals: {toast: true}  }
    end
  end

  private

  def set_post
    @post = Post.find_by_id(params[:post_id])
  end
end
