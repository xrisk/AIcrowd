class Notification::LeaderboardNotificationJob < ApplicationJob
  queue_as :default

  def perform(challenge_round_id)
    challenge_round = ChallengeRound.find(challenge_round_id)
    leaderboards    = challenge_round.leaderboards

    leaderboards.each do |leaderboard|
      NotificationService.new(leaderboard.submitter_id, leaderboard, 'leaderboard').call
    end
  end
end
