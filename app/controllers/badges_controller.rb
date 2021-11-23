class BadgesController < ApplicationController
  before_action :authenticate_participant!

  def index
    respond_to do |format|
      format.js { render :refresh }
    end
  end

  def shared_notebook
    render json: {}, status: 200
  end

  def notebook_was_shared
    render json: {}, status: 200
  end

  def downloaded_notebook
    render json: {}, status: 200
  end

  def notebook_received_download
    render json: {}, status: 200
  end

  def executed_notebook
    render json: {}, status: 200
  end

end
