FactoryBot.define do
  factory :category_challenge do
    association(:category)
    association(:challenge)
  end
end
