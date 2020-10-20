class AddChallengeLeaderboardExtraIdToBaseLeaderboard < ActiveRecord::Migration[5.2]
  def change
    add_column :base_leaderboards, :challenge_leaderboard_extra_id, :integer, :default => nil
  end
end
