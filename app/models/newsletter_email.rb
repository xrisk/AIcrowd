class NewsletterEmail < ApplicationRecord
  belongs_to :participant, class_name: 'Participant'
  belongs_to :challenge, class_name: 'Challenge', optional: true

  validates :subject, presence: true
  validates :message, presence: true
  validates :bcc, :cc, emails_list: true
end
