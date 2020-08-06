class AddDebugSubmissionToChallengeRound < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :debug_submission_limit, :string
    add_column :challenge_rounds, :debug_submission_time, :integer
  end
end
