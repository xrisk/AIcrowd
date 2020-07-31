namespace :activity_point do
  desc 'Create Activity Point'
  task create_seed_activity: :environment do
    records = [['new_challenge_signup_participation', 'New challenge signup and participation (1 graded submission in the problem you didn’t participate earlier) - once per challenge', 10], ['participated_into_editors_selected_challenge', 'Entered into editors selected challenge and participated (in addition to above points)', 20], ['score_better_than_baselines', 'Score better than baselines - once per challenge', 20], ['legendary_submission', 'Legendary submission (worth in top 3 in the leaderboard) - once per challenge', 25], ['first_submission', 'First submission in any challenge (without any condition)', 10], ['contribute_baseline', 'Contribute baseline to the community (admin approved?)', 25], ['new_category_participated', 'Challenge participated in a new category', 20], ['score_improved_over_5_times', 'The leaderboard score improved over 5 times in a day, say initially 0.1, 0.2, 0.3, 0.4, 0.5.. (important to celebrate improvement and pushing them to improve scores, which lead to understanding different concepts when they do so)', 50], ['read_baseline', 'Read baseline for the challenge (some way to measure “read”, can be done, Discourse track it afaik) - once per baseline', 20], ['executed_baseline', 'Executed baseline for the challenge (can we done by forcing aicrowd-bot login in baselines) - once per baseline (if executed, read == true, automatically)', 20], ['submission_points', 'Points on every submission', 5], ['leaderboard_rank_change', 'Change in Leaderboard rank', 10]]

    records.each do |record|
      puts "Creating ActivityPoint for key #{record[0]}..."
      ActivityPoint.create!(activity_key: record[0], description: record[1], point: record[2])
    end
  end
end
