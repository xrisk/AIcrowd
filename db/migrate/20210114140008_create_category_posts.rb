class CreateCategoryPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :category_posts do |t|
      t.references :category, null: false
      t.references :post, null: false

      t.timestamps
    end
    add_index :category_posts, [:category_id, :post_id], unique: true
  end
end
