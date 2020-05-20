class UpdateLeaderboardsToVersion24 < ActiveRecord::Migration[5.2]
  def change
    update_view :leaderboards, version: 24, revert_to_version: 23
  end
end
