class AddScoreTitlesToChallengeRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :primary_score_title, :string
    add_column :challenge_rounds, :secondary_score_title, :string
  end
end
