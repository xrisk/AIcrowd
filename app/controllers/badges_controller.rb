class BadgesController < ApplicationController
  def index
    respond_to do |format|
      format.js { render :refresh }
    end
  end
end
