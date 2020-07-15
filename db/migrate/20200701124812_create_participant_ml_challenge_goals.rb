class CreateParticipantMlChallengeGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_ml_challenge_goals do |t|
      t.integer :participant_id
      t.integer :challenge_id
      t.integer :daily_practice_goal_id

      t.timestamps
    end
  end
end
