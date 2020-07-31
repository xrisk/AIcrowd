class ChallengeProblemsPolicy < ApplicationPolicy
  def show?
    participant&.admin?
  end

  def update?
    participant&.admin?
  end

  def create?
    participant&.admin?
  end
end
