FactoryBot.define do
  factory :daily_practice_goal, class: 'DailyPracticeGoal' do
    title { 'Casual' }
    points { 100 }
    duration_text { '4-5 Months approx' }
  end
end
