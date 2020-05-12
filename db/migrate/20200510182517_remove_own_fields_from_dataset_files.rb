class RemoveOwnFieldsFromDatasetFiles < ActiveRecord::Migration[5.2]
  def change
    remove_column :dataset_files, :directory_path, :text
    remove_column :dataset_files, :aws_access_key, :text
    remove_column :dataset_files, :aws_secret_key, :text
    remove_column :dataset_files, :bucket_name, :text
    remove_column :dataset_files, :region, :text
  end
end
