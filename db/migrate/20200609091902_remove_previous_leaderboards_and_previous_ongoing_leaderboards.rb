class RemovePreviousLeaderboardsAndPreviousOngoingLeaderboards < ActiveRecord::Migration[5.2]
  def change
    drop_view :previous_leaderboards
    drop_view :previous_ongoing_leaderboards
  end
end
