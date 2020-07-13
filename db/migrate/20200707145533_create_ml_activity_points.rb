class CreateMlActivityPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :ml_activity_points do |t|
      t.integer :participant_id
      t.integer :challenge_id
      t.integer :activity_point_id

      t.timestamps
    end
  end
end
