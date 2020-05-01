class CreateChallengeProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_problems do |t|
      t.integer "challenge_id"
      t.integer "problem_id"
      t.float "weight"
    end
  end
end
