class ChallengeProblemsPolicy < ApplicationPolicy

  def show?
    (participant && (participant.admin?))
  end

  def update?
    (participant && (participant.admin?))
  end

  def create?
    (participant && (participant.admin?))
  end

end
