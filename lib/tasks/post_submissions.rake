namespace :challenge_rounds do
  desc "Migrate post submissions to rounds"
  task migrate_post_challenge_submissions_to_rounds: :environment do
    Challenge.includes(:challenge_rounds).find_each do |challenge|
      next if challenge.post_challenge_submissions.blank?
      challenge.challenge_rounds.update_all( post_challenge_submissions: challenge.post_challenge_submissions)
    end
  end
end
