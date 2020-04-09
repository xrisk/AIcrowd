class CreateDiscourseUserBadgesMeta < ActiveRecord::Migration[5.2]
  def change
    create_table :discourse_user_badges_meta do |t|
      t.integer :previous_id, default: 0, null: false

      t.timestamps
    end
  end
end
