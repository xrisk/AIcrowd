class MemberPolicy < ApplicationPolicy
  def index?
    participant&.admin? || participant&.organizer_ids&.include?(@record.id)
  end

  def show?
    false
  end

  def edit?
    index?
  end

  def update?
    index?
  end

  def new?
    false
  end

  def create?
    false
  end

  def destroy?
    index?
  end
end
