class NewsletterEmail < ApplicationRecord
  validates :emails_list, presence: true
  validates :subject, presence: true
  validates :message, presence: true
end
