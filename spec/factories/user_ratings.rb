FactoryBot.define do
  factory :user_rating do
    user { nil }
    rating { 1.5 }
    temporary_rating { 1.5 }
    variation { 1.5 }
    temporary_variation { 'MyString' }
    float { 'MyString' }
    challenge_round { nil }
  end
end
