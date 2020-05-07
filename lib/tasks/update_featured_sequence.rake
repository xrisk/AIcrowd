namespace :update_featured_sequence do
  desc "set featured_sequence value from 0 to 1"
  task increase_by_one: :environment do
    challenges = Challenge.where(featured_sequence: 0)
    challenges.each do |challenge|
      challenge.update!(featured_sequence: 1)
    end
  end

end
