class RemovePublicationIdFromPublicationAuthor < ActiveRecord::Migration[5.2]
  def change
    remove_column :publication_authors, :publication_id, :integer
  end
end
