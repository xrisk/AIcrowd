class PostPolicy < ApplicationPolicy

  def show?
    !@record.private? || (participant && (participant.admin? || (@record.participant_id == participant.id) || allow_organizers?(participant, @record.challenge)))
  end

  def update?
    (participant && (participant.admin? || @record.participant_id == participant.id))
  end

  def create?
    (participant.present?)
  end

  def destroy?
    update?
  end

  def allow_organizers participant, challenge
    (participant.organizer_ids & @record.challenge.organizer_ids).any? && challenge.organizer_notebook_access?
  end

end
