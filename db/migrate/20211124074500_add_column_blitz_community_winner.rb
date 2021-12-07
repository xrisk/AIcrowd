class AddColumnBlitzCommunityWinner < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :blitz_community_winner, :boolean, default: false
  end
end
