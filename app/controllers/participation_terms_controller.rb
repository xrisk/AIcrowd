class ParticipationTermsController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_participation_terms

  def show
    @challenge = Challenge.friendly.find(params[:challenge_id])
  end

  private

  def participation_terms_params
    params
      .require(:challenge_id)
      .permit(
        :id,
        :terms_markdown)
  end

  def set_participation_terms
    @participation_terms = ParticipationTerms.current_terms
  end
end
