class CreateMlActivityPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :ml_activity_points do |t|
      t.references :participant, null: false, foreign_key: true
      t.references :challenge, null: false, foreign_key: true
      t.references :activity_point, null: false, foreign_key: true

      t.timestamps
    end
  end
end
