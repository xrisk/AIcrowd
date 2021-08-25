class RemoveIndexFromAicrowdBadges < ActiveRecord::Migration[5.2]
  def change
    remove_index :aicrowd_badges, name: "index_aicrowd_badges_on_name"
  end
end
