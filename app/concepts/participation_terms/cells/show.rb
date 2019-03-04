class ParticipationTerms::Cell::Terms < ParticipationTerms::Cell

  def show
    render :show
  end

  def challenge
    model
  end

  def challenge_participant
    if current_participant
      @challenge_participant = challenge
        .challenge_participants
        .find_by(participant_id: current_participant.id)
    end
  end

end