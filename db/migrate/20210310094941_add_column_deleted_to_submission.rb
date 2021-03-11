class AddColumnDeletedToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :deleted, :boolean, default: false
  end
end
