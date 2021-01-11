class AddSubmissionLockingTimeToChallengeRound < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :submission_lock_time, :datetime
    add_column :challenge_rounds, :submission_lock_enabled, :boolean, default: false
    add_column :challenge_rounds, :submision_filter, :text
  end
end
