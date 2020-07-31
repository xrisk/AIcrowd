namespace :update_featured_sequence do
  desc 'set featured_sequence'
  task increase_by_one: :environment do
    challenges = Challenge.where(featured_sequence: 0)
    challenges.each do |challenge|
      next_seq = Challenge.maximum('featured_sequence') + 1
      challenge.update!(featured_sequence: next_seq)
    end
  end
end
