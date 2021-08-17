class CreatePostBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :post_bookmarks do |t|
      t.integer :post_id, null: false
      t.integer :participant_id, null: false

      t.timestamps
    end
  end
end
