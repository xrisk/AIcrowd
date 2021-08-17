class AddComunityContributionWinnerToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :community_contribution_winner, :boolean, default: false
  end
end
