class AddAwsEndpointToDatasetFolder < ActiveRecord::Migration[5.2]
  def change
    add_column :dataset_folders, :aws_endpoint, :string, default: "https://s3.amazonaws.com/"
  end
end
