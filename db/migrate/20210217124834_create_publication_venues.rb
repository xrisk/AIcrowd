class CreatePublicationVenues < ActiveRecord::Migration[5.2]
  def change
    create_table :publication_venues do |t|
      t.string :venue, null: false
      t.string :short_name
      t.integer :publication_id, null: false

      t.timestamps
    end
  end
end
