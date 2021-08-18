class AddPublicationIdToPublicationAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :publication_authors, :publication_id, :int
  end
end
