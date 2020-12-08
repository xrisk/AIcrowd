FactoryBot.define do
  factory :challenge_leaderboard_extra do
    association(:challenge_round)
  end
end
