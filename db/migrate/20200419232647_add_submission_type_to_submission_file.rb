class AddSubmissionTypeToSubmissionFile < ActiveRecord::Migration[5.2]
  def change
    add_column :submission_files, :submission_type, :text
  end
end
