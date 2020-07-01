class AddOccurDayToChallengeProblem < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_problems, :occur_day, :integer
  end
end
