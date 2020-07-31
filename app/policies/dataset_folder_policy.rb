class DatasetFolderPolicy < ApplicationPolicy
  def index?
    participant
  end

  def new?
    participant && (participant.admin? || (participant.organizer_ids & @record.challenge.organizer_ids).any?)
  end

  def create?
    new?
  end

  def edit?
    new?
  end

  def update?
    new?
  end

  def destroy?
    new?
  end

  class Scope
    attr_reader :participant, :scope

    def initialize(participant, scope)
      @participant = participant
      @scope       = scope
    end

    def resolve
      if participant&.admin?
        scope.all
      elsif participant&.organizer_ids&.any?
        scope.where('visible is true and evaluation is false').or(
          scope.where(challenge_id: Challenge.joins(:organizers).where(organizers: { id: participant.organizer_ids }).ids)
        )
      else
        scope.where('visible is true and evaluation is false')
      end
    end
  end
end
