class AddMlChallengeIdToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :ml_challenge_id, :integer
  end
end
