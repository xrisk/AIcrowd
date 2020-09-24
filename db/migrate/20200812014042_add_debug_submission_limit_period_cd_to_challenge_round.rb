class AddDebugSubmissionLimitPeriodCdToChallengeRound < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :debug_submission_limit_period_cd, :string
  end
end
