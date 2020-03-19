class CreateNewsletterEmailsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :newsletter_emails_tables do |t|
      t.text :emails_list, null: false, default: ''
      t.text :cc, null: false, default: ''
      t.text :subject, null: false, default: ''
      t.text :message, null: false, default: ''
      t.boolean :approved

      t.timestamps
    end
  end
end
