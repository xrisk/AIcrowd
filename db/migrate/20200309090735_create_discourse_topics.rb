class CreateDiscourseTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :discourse_topics do |t|
      t.string :title, null: false
      t.string :fancy_title
      t.string :slug
      t.string :archetype
      t.integer :views
      t.integer :posts_count
      t.integer :reply_count
      t.integer :like_count
      t.integer :participant_count
      t.boolean :visible, null: false, default: true
      t.boolean :closed, null: false, default: false
      t.boolean :archived, null: false, default: false
      t.datetime :last_posted_at
      t.references :discourse_category, foreign_key: true
      t.references :participant, foreign_key: true
      t.jsonb :webhook_payload, null: false, default: '{}'
    end
  end
end
