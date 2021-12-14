class RemoveForeignKeyInDatasetFileDownloads < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key "dataset_file_downloads", "dataset_files"
    remove_foreign_key "dataset_file_downloads", "participants"
  end
end
