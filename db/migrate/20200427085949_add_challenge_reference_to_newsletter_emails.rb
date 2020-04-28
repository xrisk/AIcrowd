class AddChallengeReferenceToNewsletterEmails < ActiveRecord::Migration[5.2]
  def change
    add_reference :newsletter_emails, :challenge, index: true, foreign_key: true
  end
end
