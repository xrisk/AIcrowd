class AddVisibleToTaskDatasetFile < ActiveRecord::Migration[5.2]
  def change
    add_column :task_dataset_files, :visible, :boolean, default: true
  end
end
