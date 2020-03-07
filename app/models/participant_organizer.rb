class ParticipantOrganizer < ApplicationRecord
  belongs_to :participant
  belongs_to :organizer
  validates :organizer_id, uniqueness: { scope: :participant_id }
end
