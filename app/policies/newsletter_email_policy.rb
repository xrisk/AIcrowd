class NewsletterEmailPolicy < ApplicationPolicy
  def decline?
    participant&.admin?
  end
end
