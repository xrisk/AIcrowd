class CreatePublications < ActiveRecord::Migration[5.2]
  def change
    create_table :publications do |t|
      t.string   :thumbnail
      t.string   :title
      t.text     :description
      t.date     :publication_date
      t.integer  :challenge_id
      t.integer  :no_of_citations
      t.boolean  :aicrowd_contributed
      t.string   :slug
      t.integer  :sequence, default: 0
      t.text     :cite
      t.text     :abstract
      t.timestamps
    end
  end
end
