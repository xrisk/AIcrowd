FactoryBot.define do
  factory :challenges_organizer do
    association(:challenge)
    association(:organizer)
  end
end
