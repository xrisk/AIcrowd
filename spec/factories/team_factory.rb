FactoryBot.define do
  factory :team, class: Team do
    association :challenge
    name { FFaker::Company.unique.name\
      .gsub(/ /, '_')
      .gsub(/[^a-zA-Z0-9.\-_{}\[\]]+/, '')
    }

    trait :participants do |participants|
      after :create do |team|
        participants.each do |participant|
          team.team_participants.create(participant: participant)
        end
      end
    end
  end
end
