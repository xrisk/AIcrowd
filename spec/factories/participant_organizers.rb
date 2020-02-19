FactoryBot.define do
  factory :participant_organizer do
    association(:participant)
    association(:organizer)
  end
end
