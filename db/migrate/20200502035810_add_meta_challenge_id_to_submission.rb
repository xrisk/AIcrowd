class AddMetaChallengeIdToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :meta_challenge_id, :integer
  end
end
