FactoryBot.define do
  factory :challenge_participant, class: 'ChallengeParticipant' do
    challenge_rules_accepted_date    { Time.current }
    challenge_rules_accepted_version { challenge.current_challenge_rules&.version }

    association(:challenge)
    association(:participant)
  end
end
