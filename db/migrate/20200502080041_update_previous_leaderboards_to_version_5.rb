class UpdatePreviousLeaderboardsToVersion5 < ActiveRecord::Migration[5.2]
  def change
    update_view :previous_leaderboards, version: 5, revert_to_version: 4
  end
end
