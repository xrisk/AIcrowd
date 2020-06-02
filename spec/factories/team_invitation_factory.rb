FactoryBot.define do
  factory :team_invitation do
    status { 'pending' }

    association(:team)
    association(:invitor, factory: :participant)
    association(:invitee, factory: :participant)
  end
end
