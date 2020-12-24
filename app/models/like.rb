class Like < ApplicationRecord
  belongs_to :participant
  validates :participant_id, uniqueness: {scope: [:reference_id, :reference_type]}
end
