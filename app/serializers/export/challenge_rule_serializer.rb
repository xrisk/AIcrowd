module Export
  class ChallengeRuleSerializer < ActiveModel::Serializer
    attributes(*::Challenge::IMPORTABLE_ASSOCIATIONS[:challenge_rules_attributes])
  end
end
