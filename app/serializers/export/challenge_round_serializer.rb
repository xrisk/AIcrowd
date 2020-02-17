module Export
  class ChallengeRoundSerializer < ActiveModel::Serializer
    attributes *::Challenge::IMPORTABLE_ASSOCIATIONS[:challenge_rounds_attributes]
  end
end
