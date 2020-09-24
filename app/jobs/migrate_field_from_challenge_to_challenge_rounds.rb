class MigrateFieldFromChallengeToChallengeRounds < ApplicationJob
  queue_as :default

  def perform
    fields_to_migrate = ['media_on_leaderboard', 'show_leaderboard', 'other_scores_fieldnames']
    Challenge.all.each do |challenge|
      challenge.challenge_rounds.each do |challenge_round|
        fields_to_migrate.each do |field|
          if defined? challenge[field]
            challenge_round[field] = challenge[field]
          end
        end
        challenge_round.save!
      end
      challenge.save!
    end
  end
end
