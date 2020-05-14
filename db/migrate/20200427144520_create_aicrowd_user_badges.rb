class CreateAicrowdUserBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :aicrowd_user_badges do |t|
      t.references :aicrowd_badges, foreign_key: true
      t.references :participant, foreign_key: true
      t.json :custom_fields

      t.timestamps
    end
  end
end
