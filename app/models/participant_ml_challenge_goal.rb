class ParticipantMlChallengeGoal < ApplicationRecord
  belongs_to :participant, optional: true, class_name: 'Participant'
  belongs_to :challenge, class_name: 'Challenge'
  belongs_to :daily_practice_goal, class_name: 'DailyPracticeGoal'
end
