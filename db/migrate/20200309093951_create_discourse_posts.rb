class CreateDiscoursePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :discourse_posts do |t|
      t.string :name, null: false
      t.string :username
      t.string :avatar_template
      t.text :cooked
      t.integer :post_number
      t.integer :post_type
      t.integer :reply_count
      t.integer :reply_to_post_number
      t.integer :quote_count
      t.integer :incoming_link_count
      t.integer :reads
      t.integer :score
      t.integer :version
      t.boolean :moderator, null: false, default: false
      t.boolean :admin, null: false, default: false
      t.boolean :staff, null: false, default: false
      t.boolean :hidden, null: false, default: false
      t.references :discourse_topic, foreign_key: true
      t.references :participant, foreign_key: true
      t.jsonb :webhook_payload, null: false, default: '{}'
    end
  end
end
