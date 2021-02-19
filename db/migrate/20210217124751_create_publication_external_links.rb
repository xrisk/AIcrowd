class CreatePublicationExternalLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :publication_external_links do |t|
      t.string  :name
      t.text    :link, null: false
      t.integer :publication_id, null: false
      t.string  :icon

      t.timestamps
    end
  end
end
