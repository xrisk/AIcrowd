class CreateJoinTablePublicationsPublicationVenues < ActiveRecord::Migration[5.2]
  def change
    create_join_table :publications, :publication_venues do |t|
      # t.index [:publication_id, :publication_venue_id]
      # t.index [:publication_venue_id, :publication_id]
    end
  end
end
