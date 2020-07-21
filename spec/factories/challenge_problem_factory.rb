FactoryBot.define do
  factory :challenge_problem, class: 'ChallengeProblems' do
    weight { 0.5 }

    association(:challenge)
    association(:challenge_round)
    association(:problem, factory: :challenge)
  end
end
