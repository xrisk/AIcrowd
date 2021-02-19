class CreatePublicationAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :publication_authors do |t|
      t.string  :name
      t.integer :participant_id
      t.integer :publication_id, null: false
      t.integer :sequence, default: 0

      t.timestamps
    end
  end
end
