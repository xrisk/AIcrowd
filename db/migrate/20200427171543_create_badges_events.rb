class CreateBadgesEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :badges_events do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
