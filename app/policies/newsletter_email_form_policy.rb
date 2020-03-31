class NewsletterEmailFormPolicy < ApplicationPolicy
  def new?
    @record.participant && (@record.participant.admin? || (@record.participant.organizer_ids & @record.challenge.organizer_ids).any?)
  end

  def create?
    new?
  end
end
