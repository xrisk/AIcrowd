class AddUseChallengeDatasetFilesToClefTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :clef_tasks, :use_challenge_dataset_files, :boolean, null: false, default: false
  end
end
