FactoryBot.define do
  factory :newsletter_email do
    emails_list { 'test@example.com' }
    cc          { 'cc@example.com' }
    subject     { 'Email Subject' }
    message     { 'Email Message' }
    pending     { true }
  end
end
