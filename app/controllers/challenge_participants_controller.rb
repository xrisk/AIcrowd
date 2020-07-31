class ChallengeParticipantsController < ApplicationController
  before_action :authenticate_participant!

  def create
    @challenge                            = Challenge.friendly.find(params[:challenge_id])
    @challenge_participant                = @challenge.challenge_participants.new(challenge_participant_params)
    @challenge_participant.participant_id = current_participant.id

    authorize @challenge_participant

    if @challenge_participant.save
      redirect_to(session[:forwarding_url] || @challenge)
      session.delete(:forwarding_url)
    else
      render :new
    end
  end

  def update
    @challenge_participant = ChallengeParticipant.find(params[:id])
    authorize @challenge_participant
    @challenge_participant.challenge_rules_accepted_date    = Time.now
    @challenge_participant.challenge_rules_accepted_version = @challenge_participant.challenge.current_challenge_rules&.version
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

  def challenge_participant_params
    params
      .require(:challenge_participant)
      .permit(
        :challenge_rules_additional_checkbox,
        :challenge_rules_accepted_version
      )
  end
end
