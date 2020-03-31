class UpdateNewsletterEmailsFields < ActiveRecord::Migration[5.2]
  def change
    rename_column :newsletter_emails, :emails_list, :bcc
    change_column :newsletter_emails, :bcc, :text, default: ''
    add_reference :newsletter_emails, :participant, foreign_key: true
  end
end
