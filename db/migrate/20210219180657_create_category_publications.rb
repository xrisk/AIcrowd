class CreateCategoryPublications < ActiveRecord::Migration[5.2]
  def change
    create_table :category_publications do |t|
      t.references :category, null: false
      t.references :publication, null: false

      t.timestamps
    end
    add_index :category_publications, [:category_id, :publication_id], unique: true
  end
end
