class AddSubModuleToAicrowdBadge < ActiveRecord::Migration[5.2]
  def change
    add_column :aicrowd_badges, :sub_module, :text
  end
end
