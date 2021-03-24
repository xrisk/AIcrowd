class AddShowSubmissionToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :show_submission, :boolean, default: true
  end
end
