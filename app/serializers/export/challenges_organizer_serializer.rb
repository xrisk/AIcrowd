module Export
  class ChallengesOrganizerSerializer < ActiveModel::Serializer
    attributes(*::Challenge::IMPORTABLE_ASSOCIATIONS[:challenges_organizers_attributes])
  end
end
