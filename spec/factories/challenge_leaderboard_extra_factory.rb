FactoryBot.define do
  factory :challenge_leaderboard_extra do
    score_precision           { 3 }
    score_secondary_precision { 3 }
    ranking_window            { 48 }
    score_title               { 'Score Title'}
    score_secondary_title     { 'Secondary Score Title' }

    association(:challenge_round)
  end
end
