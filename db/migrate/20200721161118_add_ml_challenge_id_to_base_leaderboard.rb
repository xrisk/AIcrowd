class AddMlChallengeIdToBaseLeaderboard < ActiveRecord::Migration[5.2]
  def change
    add_column :base_leaderboards, :ml_challenge_id, :integer
    add_index :base_leaderboards, :ml_challenge_id
  end
end
