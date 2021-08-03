class RemovePublicationIdFromPublicationVenue < ActiveRecord::Migration[5.2]
  def change
    remove_column :publication_venues, :publication_id, :integer
  end
end
