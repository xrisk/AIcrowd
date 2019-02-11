class ChallengeRules < ApplicationRecord
  include Markdownable
  belongs_to :challenge

  before_create do
    if self.challenge.current_challenge_rules
      self.version = self.challenge.current_challenge_rules.version + 1
    else
      self.version = 1
    end
  end
end
