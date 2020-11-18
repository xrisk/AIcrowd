class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :tagline
      t.text :description
      t.string :external_link
      t.integer :challenge_id
      t.integer :submission_id
      t.text :thumbnail
      t.text :notebook_html

      t.timestamps
    end
  end
end
