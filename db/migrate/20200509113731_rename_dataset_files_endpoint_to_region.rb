class RenameDatasetFilesEndpointToRegion < ActiveRecord::Migration[5.2]
  def change
    rename_column :dataset_files, :endpoint, :region
  end
end
