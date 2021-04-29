class BaselinesController < ApplicationController
  before_action :check_params

  def index
    challenge_id = params[:challenge_id]
    baselines = Baseline.where(challenge_id: challenge_id)
    if baselines.present?
      render json: {baselines: baselines}, status: :ok
    else
      render json: {}, status: :not_found
    end
  end

  private

  def check_params
    render json: {}, status: :unauthorized if params[:challenge_id].blank?
  end
end