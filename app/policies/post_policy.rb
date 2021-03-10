class PostPolicy < ApplicationPolicy

  def show?
    !@record.private? || (participant && (participant.admin? || @record.participant_id == participant.id))
  end

  def update?
    (participant && (participant.admin? || @record.participant_id == participant.id))
  end

  def create?
    (participant.present?)
  end

end
