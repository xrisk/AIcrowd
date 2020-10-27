class ChallengeParticipantsController < ApplicationController
  before_action :authenticate_participant!

  def create
    @challenge                            = Challenge.friendly.find(params[:challenge_id])
    @challenge_participant                = @challenge.challenge_participants.new(challenge_participant_params)
    @challenge_participant.participant_id = current_participant.id

    authorize @challenge_participant

    if @challenge_participant.save
      accept_non_exclusive_challenge_rules(@challenge, current_participant)
      accept_participation_terms(current_participant)
      redirect_to(session[:forwarding_url] || @challenge)
      session.delete(:forwarding_url)
    else
      render :new
    end
  end

  def update
    @challenge_participant = ChallengeParticipant.find(params[:id])
    authorize @challenge_participant
    @challenge_participant.registered = true
    @challenge_participant.challenge_rules_accepted_date    = Time.now
    @challenge_participant.challenge_rules_accepted_version = @challenge_participant.challenge.current_challenge_rules&.version
    if params[:challenge_participant][:registration_form_details].present?
      @challenge_participant.registration_form_details        = params[:challenge_participant][:registration_form_details]
    end
    accept_non_exclusive_challenge_rules(@challenge_participant.challenge, current_participant)
    accept_participation_terms(current_participant)
    if @challenge_participant.update(challenge_participant_params)
      if @challenge_participant.challenge.ml_challenge
        redirect_to daily_practice_goals_path(challenge_id: @challenge_participant.challenge.slug)
      else
        redirect_to(stored_location_for(:user) || @challenge_participant.challenge)
        session.delete(:forwarding_url)
      end
    else
      render :edit
    end
  end

  private

  def accept_participation_terms(participant)
    if !participant.has_accepted_participation_terms?
      participant.participation_terms_accepted_date = Time.now
      participant.participation_terms_accepted_version = ParticipationTerms.current_terms&.version
      participant.save!
    end
  end

  def accept_non_exclusive_challenge_rules(challenge, participant)
    if challenge.meta_challenge? && challenge.challenge_problems.where(exclusive: false).present?
      challenge.challenge_problems.where(exclusive: false).each do |challenge_problem|
        challenge_participant =
          ChallengeParticipant
          .where(challenge_id: challenge_problem.problem.id, participant_id: participant.id)
          .first_or_create
        challenge_participant.challenge_rules_accepted_version = challenge_problem.problem.current_challenge_rules.version
        challenge_participant.registered = true
        challenge_participant.challenge_rules_accepted_date    = Time.now
        challenge_participant.save!
      end
    end
  end

  def challenge_participant_params
    params
      .require(:challenge_participant)
      .permit(
        :challenge_rules_additional_checkbox,
        :challenge_rules_accepted_version,
        :registration_form_details
      )
  end

end
