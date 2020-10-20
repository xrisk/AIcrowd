class CreateChallengeLeaderboardExtras < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_leaderboard_extras do |t|
      t.integer :challenge_id
      t.string :filter
      t.string :name

      t.timestamps
    end
  end
end
