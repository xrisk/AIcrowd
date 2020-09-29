class AddSubmissionLinkToBaseLeaderboard < ActiveRecord::Migration[5.2]
  def change
    add_column :base_leaderboards, :submission_link, :text
  end
end
