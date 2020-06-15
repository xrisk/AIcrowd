class CalculateLeaderboardJob < ApplicationJob
  queue_as :default

  def perform(challenge_round_id:)
    if ChallengeRound.find(challenge_round_id).challenge.challenge == "NeurIPS 2019 : Disentanglement Challenge"
      NewCalculateLeaderboardService.new(challenge_round_id: challenge_round_id).call
    elsif ChallengeRound.find(challenge_round_id).challenge.meta_challenge
      CalculateMetaLeaderboardService.new(challenge_id: ChallengeRound.find(challenge_round_id).challenge.id).call
    else
      ChallengeRounds::CreateLeaderboardsService.new(challenge_round: ChallengeRound.find(challenge_round_id)).call
      # Trigger all the leaderboard computations in case this round_id is being used for meta challenge
      ChallengeProblems.where(challenge_round_id: challenge_round_id).each do |challenge_problem|
        ChallengeRounds::CreateLeaderboardsService.new(challenge_round: ChallengeRound.find(challenge_round_id), meta_challenge_id: challenge_problem.challenge_id).call
        CalculateMetaLeaderboardService.new(challenge_id: challenge_problem.challenge_id).call
      end
    end
    Notification::LeaderboardNotificationJob.perform_now(challenge_round_id)
  end
end
