class AddDiscourseGroupNameToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :discourse_group_name, :string
  end
end
