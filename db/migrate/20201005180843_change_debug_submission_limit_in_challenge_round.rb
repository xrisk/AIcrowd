class ChangeDebugSubmissionLimitInChallengeRound < ActiveRecord::Migration[5.2]
  def up
    ChallengeRound.where(debug_submission_limit: '').update_all(debug_submission_limit: 0)
    change_column :challenge_rounds, :debug_submission_limit, 'integer USING CAST(debug_submission_limit AS integer)'
    change_column_default :challenge_rounds, :debug_submission_limit, 0
  end

  def down
  end
end
