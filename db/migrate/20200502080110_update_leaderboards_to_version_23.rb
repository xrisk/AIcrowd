class UpdateLeaderboardsToVersion23 < ActiveRecord::Migration[5.2]
  def change
    update_view :leaderboards, version: 23, revert_to_version: 22
  end
end
