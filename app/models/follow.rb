class Follow < ApplicationRecord
  belongs_to :followable, polymorphic: true
  belongs_to :participant, optional: true

  scope :participant_type, -> { where(followable_type: 'Participant') }
end
