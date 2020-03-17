namespace :ahoy_visits do
  desc "Add location info to existing Ahoy Visits"
  task update_location: :environment do
    Ahoy::Visit.find_each do |visit|
      next if visit.country.present?

      puts "Processing #{visit.id}"
      Ahoy::GeocodeJob.perform_now(visit)
      puts "Processed #{visit.id}"
    end
  end

  desc "Detect location for participants"
  task update_participant_location: :environment do
    Participant.find_each(&:detect_country)
  end
end
