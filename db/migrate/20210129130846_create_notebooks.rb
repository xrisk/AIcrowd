class CreateNotebooks < ActiveRecord::Migration[5.2]
  def change
    create_table :notebooks do |t|
      t.integer :notebookable_id
      t.string :notebookable_type
      t.text :notebook_html
      t.text :s3_url
      t.string :gist_id

      t.timestamps
    end
  end
end
