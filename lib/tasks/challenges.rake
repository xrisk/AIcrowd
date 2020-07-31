namespace :challenges do
  desc 'Migrate challenges score titles to rounds score titles'
  task migrate_score_titles_to_rounds: :environment do
    Challenge.includes(:challenge_rounds).find_each do |challenge|
      next if challenge.score_title.blank? &&
              challenge.score_secondary_title.blank? &&
              challenge.primary_sort_order_cd.blank? &&
              challenge.secondary_sort_order_cd.blank?

      challenge.challenge_rounds.update_all(
        score_title:             challenge.score_title,
        score_secondary_title:   challenge.score_secondary_title,
        primary_sort_order_cd:   challenge.primary_sort_order_cd,
        secondary_sort_order_cd: challenge.secondary_sort_order_cd
      )

      puts "##{challenge.id} Challenge - finished migration of score titles."
    end
  end

  desc 'Migrate description headings for all challenges (h1 -> h2, h2 -> h3, h3 -> h4)'
  task migrate_all_challenge_descriptions: :environment do
    puts 'Migration for all challenge descriptions started'
    Challenge.all.find_each do |challenge|
      next if challenge.description.blank?

      puts "Migrating description for challenge #{challenge.challenge}"
      new_description = change_headings_in_text(challenge.description)
      challenge.update!(description: new_description)
    end
  end

  def change_headings_in_text(input_text)
    8.downto(1) do |x|
      input_text.gsub!("<h#{x}>", "<h#{x + 1}>")
      input_text.gsub!("</h#{x}>", "</h#{x + 1}>")
    end
    input_text
  end

  desc 'Take weights from a weights.csv file and add weights to the corresponding challenge'
  task update_challenge_weights: :environment do
    CSV.foreach('weights.csv', headers: true) do |row|
      row              = row.to_hash
      challenge_id     = row['id']
      challenge_weight = row['weight']
      challenge_weight = 0 if challenge_weight.nil?
      Challenge.find_by(id: challenge_id).update_attribute(:weight, challenge_weight)
    end
  end

  desc 'Update gitlab evaluator type challenge_rounds to use gitlab submissions_type'
  task update_challenge_rounds_submissions_type: :environment do
    Challenge.includes(:challenge_rounds).where(evaluator_type_cd: 'gitlab').find_each do |challenge|
      challenge.challenge_rounds.update_all(submissions_type_cd: 'gitlab')

      puts "##{challenge.id} Challenge - finished update of challenge rounds submissions_type"
    end
  end
end
