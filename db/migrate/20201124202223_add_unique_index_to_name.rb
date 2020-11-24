class AddUniqueIndexToName < ActiveRecord::Migration[5.2]
  def change
    add_index :participants, :name, unique: true
  end
end
