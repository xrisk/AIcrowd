class CreateNewsletterEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :newsletter_emails do |t|
      t.text :emails_list, null: false
      t.text :cc, null: false, default: ''
      t.text :subject, null: false
      t.text :message, null: false
      t.boolean :pending, null: false, default: true

      t.timestamps
    end
  end
end
