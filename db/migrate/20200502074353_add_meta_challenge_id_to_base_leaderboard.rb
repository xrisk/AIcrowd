class AddMetaChallengeIdToBaseLeaderboard < ActiveRecord::Migration[5.2]
  def change
    add_column :base_leaderboards, :meta_challenge_id, :integer
  end
end
