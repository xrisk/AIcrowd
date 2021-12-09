class AddExternalUrlToDatasetFileDownloads < ActiveRecord::Migration[5.2]
  def change
    add_column :dataset_file_downloads, :external_url, :string
  end
end
