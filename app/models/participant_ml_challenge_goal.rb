class ParticipantMlChallengeGoal < ApplicationRecord
  belongs_to :participant, optional: true
  belongs_to :challenge
  belongs_to :daily_practice_goal
end
