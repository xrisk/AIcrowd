class CreateDiscourseCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :discourse_categories do |t|
      t.string :name, null: false, uniqueness: true
      t.string :color
      t.string :text_color
      t.string :slug
      t.string :topic_url
      t.text :description
      t.text :description_text
      t.text :description_excerpt
      t.integer :topic_count
      t.integer :post_count
      t.integer :position
      t.integer :num_featured_topics
      t.boolean :read_restricted, null: false, default: false
      t.jsonb :webhook_payload, null: false, default: '{}'
    end

    add_index :discourse_categories, :name, unique: true
  end
end
