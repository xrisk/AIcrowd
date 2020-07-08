class DailyPracticeGoal < ApplicationRecord
  validates :title, :points, presence: true

  has_many :participant_ml_challenge_goals, dependent: :destroy
end
