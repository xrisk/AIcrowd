class AddChallengeIdAndDatasetFolderIdToDatasetFileDownloads < ActiveRecord::Migration[5.2]
  def change
    add_column :dataset_file_downloads, :challenge_id, :integer
    add_column :dataset_file_downloads, :dataset_folder_id, :integer
    add_column :dataset_file_downloads, :dataset_folder_path, :string
    add_column :dataset_file_downloads, :downloaded, :boolean, default: false
  end
end
