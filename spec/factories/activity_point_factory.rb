FactoryBot.define do
  factory :activity_point, class: 'ActivityPoint' do
    activity_key { 'new_challenge_signup_participation' }
    description  { 'New challenge signup and participation (1 graded submission in the problem you didn’t participate earlier) - once per challenge' }
    point        { 10 }
  end
end
