class ClefTaskPolicy < ChallengePolicy
  def new?
    participant && (participant.admin? || participant.organizer_ids.include?(@record.organizer_id))
  end

  def edit?
    new?
  end
end
