class CreateMlActivityPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :ml_activity_points do |t|
      t.references :participant, foreign_key: true
      t.references :challenge, foreign_key: true
      t.references :activity_point, foreign_key: true

      t.timestamps
    end
  end
end
