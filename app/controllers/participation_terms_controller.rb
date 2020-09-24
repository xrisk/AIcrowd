class ParticipationTermsController < ApplicationController
  before_action :set_participation_terms

  def show
    if !current_user
        redirect_to new_participant_registration_path
    end
    @challenge = Challenge.friendly.find(params[:challenge_id])
  end

  private

  def set_participation_terms
    @participation_terms = ParticipationTerms.current_terms
  end
end
