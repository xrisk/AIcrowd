class RatingsController < ApplicationController

  def index
  end

  def create
    Rating.create!(rating_params["_json"])
    # Now send notifications
    #
  end

  private

  def rating_params
    params.permit!
  end


end