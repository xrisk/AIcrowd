class AddMlChallengeIdToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :ml_challenge_id, :integer
    add_index :submissions, :ml_challenge_id
  end
end
