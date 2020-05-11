class CreateDatasetFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :dataset_folders do |t|
      t.text :title, null: false
      t.text :description
      t.text :directory_path, null: false
      t.string :aws_access_key, null: false
      t.string :aws_secret_key, null: false
      t.text :bucket_name, null: false
      t.string :region, null: false
      t.boolean :visible, null: false, default: true
      t.boolean :evaluation, null: false, default: false
      t.references :challenge, foreign_key: true, null: false

      t.timestamps
    end
  end
end
