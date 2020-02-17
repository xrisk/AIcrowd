class ParticipantOrganizer < ApplicationRecord
  belongs_to :participant
  belongs_to :organizer
end
