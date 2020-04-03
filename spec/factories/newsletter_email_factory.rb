FactoryBot.define do
  factory :newsletter_email do
    bcc     { 'test@example.com' }
    cc      { 'cc@example.com' }
    subject { 'Email Subject' }
    message { 'Email Message' }
    pending { true }

    association(:participant)
  end
end
