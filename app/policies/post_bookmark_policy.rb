class PostBookmarkPolicy < ApplicationPolicy

  def create?
    (participant.present?)
  end

  def destroy?
    (participant && (participant.admin? || @record.participant_id == participant.id))
  end

end