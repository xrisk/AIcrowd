module Export
  class CategoryChallengeSerializer < ActiveModel::Serializer
    attributes(*::Challenge::IMPORTABLE_ASSOCIATIONS[:category_challenges_attributes])
  end
end
