class AddDeclinedToNewsletterEmails < ActiveRecord::Migration[5.2]
  def change
    add_column :newsletter_emails, :declined, :boolean, null: false, default: false
  end
end
