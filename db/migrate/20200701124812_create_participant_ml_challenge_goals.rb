class CreateParticipantMlChallengeGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_ml_challenge_goals do |t|
      t.references :participant, foreign_key: true
      t.references :challenge, foreign_key: true
      t.references :daily_practice_goal, foreign_key: true

      t.timestamps
    end
  end
end
