class MlActivityPoint < ApplicationRecord
  belongs_to :participant
  belongs_to :challenge
  belongs_to :activity_point
end
