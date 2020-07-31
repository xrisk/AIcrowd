class CreateParticipantMlChallengeGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_ml_challenge_goals do |t|
      t.references :participant, null: false, foreign_key: true
      t.references :challenge, null: false, foreign_key: true
      t.references :daily_practice_goal, null: false, foreign_key: true

      t.timestamps
      t.index [:participant_id, :challenge_id, :daily_practice_goal_id], name: 'participant_challenge_goal_id', unique: true
    end
  end
end
