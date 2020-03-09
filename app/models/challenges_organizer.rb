class ChallengesOrganizer < ApplicationRecord
  belongs_to :challenge, class_name: 'Challenge'
  belongs_to :organizer, class_name: 'Organizer'

  validates :organizer_id, uniqueness: { scope: :challenge_id }
end
