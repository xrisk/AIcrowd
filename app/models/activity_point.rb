class ActivityPoint < ApplicationRecord
  validates :activity_key, uniqueness: true, presence: true
  validates :point, presence: true

  has_many :ml_activity_points, dependent: :destroy
end
