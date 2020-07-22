FactoryBot.define do
  factory :feedback, class: 'Feedback' do
    message { '<p>Feedback message</p>' }
    association(:participant)
  end
end
