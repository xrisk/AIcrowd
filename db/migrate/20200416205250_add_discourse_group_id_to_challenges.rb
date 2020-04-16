class AddDiscourseGroupIdToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :discourse_group_id, :bigint
  end
end
