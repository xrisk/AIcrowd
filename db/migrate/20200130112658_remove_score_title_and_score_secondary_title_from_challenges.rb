class RemoveScoreTitleAndScoreSecondaryTitleFromChallenges < ActiveRecord::Migration[5.2]
  def change
    remove_column :challenges, :score_title, :string
    remove_column :challenges, :score_secondary_title, :string
  end
end
