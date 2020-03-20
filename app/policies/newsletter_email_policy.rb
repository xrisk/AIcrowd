class NewsletterEmailPolicy < ApplicationPolicy
  def new
    participant && (participant.admin? || (participant.organizer_ids & @record.organizer_ids).any?)
  end

  def create
    new?
  end
end
