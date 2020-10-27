class ChallengeRulesController < ApplicationController
  before_action :set_challenge_rules
  before_action :set_participation_terms

  def show; end

  private

  def set_participation_terms
    if current_participant.present? && !policy(@challenge).has_accepted_participation_terms?
      @participation_terms = ParticipationTerms.current_terms
    end
  end

  def set_challenge_rules
    @challenge = Challenge.friendly.find(params[:challenge_id])

    @challenge_rules = if params[:id].present?
                         @challenge.challenge_rules.find(params[:id])
                       else
                         @challenge.current_challenge_rules
                       end

    raise ActionController::RoutingError, 'Not Found' if @challenge_rules.blank?

    if current_participant.present?
      authorize @challenge

      @challenge_participant =
      ChallengeParticipant
        .where(challenge_id: @challenge.id, participant_id: current_participant.id)
        .first_or_create
      @challenge_participant.challenge_rules_accepted_version = @challenge_rules.version
    end

    if @challenge.draft? || @challenge.private_challenge?
      if !current_participant.present?
        raise ActionController::RoutingError, 'Not Found'
      end
    end
  end
end
