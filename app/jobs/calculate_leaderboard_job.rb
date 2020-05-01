class CalculateLeaderboardJob < ApplicationJob
  queue_as :default

  def perform(challenge_round_id:)
    if ChallengeRound.find(challenge_round_id).challenge.challenge == "NeurIPS 2019 : Disentanglement Challenge"
      NewCalculateLeaderboardService.new(challenge_round_id: challenge_round_id).call
    elsif ChallengeRound.find(challenge_round_id).challenge.meta_challenge
      CalculateMetaLeaderboardService.new(challenge_id: ChallengeRound.find(challenge_round_id).challenge.id).call
    else
      CalculateLeaderboardService.new(challenge_round_id: challenge_round_id).call
      ChallengeProblems.where(challenge_round_id: challenge_round_id).each do |challenge_problem|
        CalculateMetaLeaderboardService.new(challenge_id: challenge_problem.challenge_id).call
      end
    end
  end
end
