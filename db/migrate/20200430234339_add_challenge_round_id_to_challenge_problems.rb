class AddChallengeRoundIdToChallengeProblems < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_problems, :challenge_round_id, :integer
  end
end
