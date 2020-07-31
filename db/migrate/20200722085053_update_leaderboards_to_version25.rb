class UpdateLeaderboardsToVersion25 < ActiveRecord::Migration[5.2]
  def change
    update_view :leaderboards, version: 25, revert_to_version: 24
  end
end
