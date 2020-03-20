class NewsletterEmailForm
  include ActiveModel::Model

  attr_accessor :to, :cc, :bcc, :subject, :message

  validates :to, :subject, :message, presence: true

  # def initialize(params= {})
  #   @newsletter_email = NewsletterEmail.new
  #   super(params)
  # end

  # def call
  #   return false if invalid?
  #   # send acknowledgement reply, and admin notification emails, etc
  #   true
  # end

  # private

  # def person_is_valid
  #   errors.add(:base, 'is invalid') if newsletter_email.invalid?
  # end
end
