FactoryBot.define do
  factory :challenge_property, class: 'ChallengeProperty' do
    association :challenge
    page_views { 10 }
  end
end
