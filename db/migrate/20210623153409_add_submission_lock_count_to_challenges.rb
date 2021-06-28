class AddSubmissionLockCountToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :submission_lock_count, :integer, default: 1
  end
end
