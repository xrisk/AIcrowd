class CreateJoinTablePublicationsPublicationAuthors < ActiveRecord::Migration[5.2]
  def change
    create_join_table :publications, :publication_authors do |t|
      # t.index [:publication_id, :publication_author_id]
      # t.index [:publication_author_id, :publication_id]
    end
  end
end
