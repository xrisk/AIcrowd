class DatasetFolderPolicy < ApplicationPolicy
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
      if participant && (participant.admin? || participant.organizers.present?)
        scope.all
      else
        scope.where(visible: true, evaluation: false)
      end
    end
  end
end
