namespace :create_daily_practice_goal do
  desc 'create Daily Practice Goal'
  task seed_record: :environment do
    records = [['Casual', 100, '4-5 Months approx'], ['Regular', 200, '3 Months approx'], ['Serious', 350, '2 Months approx'], ['Insane', 500, '1 Months approx']]

    records.each do |record|
      daily_practice_goal = DailyPracticeGoal.create!(title: record[0], points: record[1], duration_text: record[2])
      puts "Create DailyPracticeGoal ##{daily_practice_goal.id}"
    end
  end
end
