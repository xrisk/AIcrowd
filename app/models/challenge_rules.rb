class ChallengeRules < ApplicationRecord
  include Markdownable
  belongs_to :challenge

  before_create do
    self.version = challenge&.current_challenge_rules&.version.to_i + 1
  end
end
