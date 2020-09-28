class AddExclusiveToChallengeProblems < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_problems, :exclusive, :boolean, :default => true
  end
end
