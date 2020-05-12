class AddOwnS3ColumnsToDatasetFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :dataset_files, :directory_path, :text
    add_column :dataset_files, :aws_access_key, :text
    add_column :dataset_files, :aws_secret_key, :text
    add_column :dataset_files, :bucket_name, :text
    add_column :dataset_files, :endpoint, :text
  end
end
