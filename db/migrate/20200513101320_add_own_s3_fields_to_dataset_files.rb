class AddOwnS3FieldsToDatasetFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :dataset_files, :file_path, :text
    add_column :dataset_files, :aws_access_key, :string
    add_column :dataset_files, :aws_secret_key, :string
    add_column :dataset_files, :bucket_name, :text
    add_column :dataset_files, :region, :string
  end
end
