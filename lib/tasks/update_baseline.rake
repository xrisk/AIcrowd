namespace :update_baseline do
  desc 'set baseline'
  task change_to_false: :environment do
    base_leaderboards = BaseLeaderboard.where(baseline: nil)
    base_leaderboards.update_all(baseline: false)
  end
end
