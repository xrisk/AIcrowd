class AddDebugSubmissionToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :debug_submission, :boolean, default: false, null: false
  end
end
