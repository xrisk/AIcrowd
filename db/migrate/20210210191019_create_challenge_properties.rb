class CreateChallengeProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_properties do |t|
      t.integer :page_views
      t.integer :challenge_id

      t.timestamps
    end
  end
end
