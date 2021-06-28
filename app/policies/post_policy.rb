class PostPolicy < ApplicationPolicy

  def show?
    !@record.private? || (participant && (participant.admin? || (@record.participant_id == participant.id) || (participant.organizer_ids & @record.challenge.organizer_ids).any?))
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

end
