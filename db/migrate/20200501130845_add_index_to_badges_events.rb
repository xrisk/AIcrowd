class AddIndexToBadgesEvents < ActiveRecord::Migration[5.2]
  def change
    add_index :badges_events, :name, unique: true
  end
end
