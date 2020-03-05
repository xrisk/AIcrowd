class OrganizerPolicy < ApplicationPolicy
  def index?
    false
  end

  def show?
    true
  end

  def edit?
    participant&.admin? || participant && participant.organizers.ids.include?(@record.id)
  end

  def update?
    edit?
  end

  def new?
    false
  end

  def create?
    participant&.admin?
  end

  def destroy?
    participant&.admin? || participant && participant.organizers.ids.include?(@record.id)
  end

  def regen_api_key?
    update?
  end

  def remove_image?
    update?
  end

  def members?
    edit?
  end

  def clef_email?
    participant&.admin? || participant && participant.organizers.ids.include?(@record.id)
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
      else
        if participant&.organizers&.any?
          scope.where("id = ?", participant.organizer_ids)
        else
          scope.none
        end
      end
    end
  end
end
