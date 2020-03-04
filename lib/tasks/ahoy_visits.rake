namespace :ahoy_visits do
  desc "Add location info to existing Ahoy Visits"
  task update_location: :environment do
    Ahoy::Visit.all.each do |visit|
      Ahoy::GeocodeJob.perform_now(visit)
    end
  end
end
