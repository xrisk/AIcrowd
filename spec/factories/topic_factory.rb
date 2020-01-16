FactoryBot.define do
  factory :topic, class: 'Topic' do
    challenge
    participant
    topic { FFaker::Lorem.sentence(3) }
    sticky { false }
    views { 1 }

    trait :invalid do
      topic { nil }
    end
  end
end
