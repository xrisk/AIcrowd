namespace :challenge_rounds do
  desc "Migrate challenges client names to rounds score"
  task migrate_client_name_to_rounds: :environment do
    Challenge.includes(:challenge_rounds).find_each do |challenge|
      next if challenge.challenge_client_name.blank?

      challenge.challenge_rounds.update_all(
          challenge_client_name:  challenge.challenge_client_name
      )

      puts "##{challenge.id} Challenge - finished migration of client names."
    end
  end
end
