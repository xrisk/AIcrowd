class ParticipationTerms < ApplicationRecord
  include Markdownable

  before_create do
    if self.class.current_terms
      self.version = self.class.current_terms.version + 1
    else
      self.version = 1
    end
  end

  def self.current_terms
    self.order('version desc').first
  end
end
