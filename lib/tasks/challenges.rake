namespace :challenges do
  desc "Migrate challenges score titles to rounds score titles"
  task migrate_score_titles_to_rounds: :environment do
    Challenge.includes(:challenge_rounds).find_each do |challenge|
      next if challenge.score_title.blank? && challenge.score_secondary_title.blank?

      challenge.challenge_rounds.update_all(
        score_title:           challenge.score_title,
        score_secondary_title: challenge.score_secondary_title
      )

      puts "##{challenge.id} Challenge - finished migration of score titles."
    end
  end
end
