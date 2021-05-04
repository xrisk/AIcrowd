class AddNewIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :posts, :created_at
    add_index :submissions, :deleted
  end
end
