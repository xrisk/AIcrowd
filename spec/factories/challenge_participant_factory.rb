FactoryBot.define do
  factory :challenge_participant, class: ChallengeParticipant do
    challenge
    participant
    accepted_dataset_toc true
    challenge_rules_accepted_date Time.now
    challenge_rules_accepted_version 1
  end
end