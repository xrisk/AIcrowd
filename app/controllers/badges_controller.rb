class BadgesController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_post, except: [:index]

  def index
    respond_to do |format|
      format.js { render :refresh }
    end
  end

  def shared_notebook
    render json: {}, status: 200
  end

  def downloaded_notebook
    render json: {}, status: 200
  end

  def executed_notebook
    render json: {}, status: 200
  end

  private

  def set_post
    @post = Post.find_by_id(params[:id])
  end

end
