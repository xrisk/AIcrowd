class CreateChallengeProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_properties do |t|
      t.integer :page_views, default: 0, null: false
      t.integer :challenge_id, null: false

      t.timestamps
    end
  end
end
