class Notification::LeaderboardNotificationJob < ApplicationJob
  queue_as :default

  def perform(challenge_round_id)
    challenge_round = ChallengeRound.find(challenge_round_id)
    leaderboards    = challenge_round.leaderboards
    leaderboards    = leaderboards.where(challenge_leaderboard_extra_id: challenge_round.default_leaderboard)

    leaderboards.each do |leaderboard|
      if leaderboard.submitter_type == 'Team'
        TeamParticipant.where(team_id: leaderboard.submitter_id).each do |team_participant|
          NotificationService.new(team_participant.participant_id, leaderboard, 'leaderboard').call
        end
      else
        NotificationService.new(leaderboard.submitter_id, leaderboard, 'leaderboard').call
      end
    end
  end
end
