class VotePolicy < ApplicationPolicy
  def create?
    participant
  end

  def edit?
    participant && (participant.admin? || @record.participant == participant)
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def white_vote_create?
    create?
  end
end
