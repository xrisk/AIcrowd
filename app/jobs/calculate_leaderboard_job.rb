class CalculateLeaderboardJob < ApplicationJob
  queue_as :default

  def perform(challenge_round_id:)
    # This challenge has custom logic that takes 5 different scores and calculates average of them, thus we cannot recalculate
    # leaderboards records with ChallengeRounds::CreateLeaderboardsService class.
    return if ChallengeRound.find(challenge_round_id).challenge.challenge == "NeurIPS 2019 : Disentanglement Challenge"

    if ChallengeRound.find(challenge_round_id).challenge.meta_challenge || ChallengeRound.find(challenge_round_id).challenge.ml_challenge
      CalculateMetaLeaderboardService.new(challenge_id: ChallengeRound.find(challenge_round_id).challenge.id).call
    else
      ChallengeRounds::CreateLeaderboardsService.new(challenge_round: ChallengeRound.find(challenge_round_id)).call

      # Trigger all the leaderboard computations in case this round_id is being used for meta challenge
      ChallengeProblems.where(challenge_round_id: challenge_round_id).each do |challenge_problem|
        if challenge_problem.challenge.ml_challenge
          ChallengeRounds::CreateLeaderboardsService.new(challenge_round: ChallengeRound.find(challenge_round_id), ml_challenge_id: challenge_problem.challenge_id).call
        else
          ChallengeRounds::CreateLeaderboardsService.new(challenge_round: ChallengeRound.find(challenge_round_id), meta_challenge_id: challenge_problem.challenge_id).call
        end
        CalculateMetaLeaderboardService.new(challenge_id: challenge_problem.challenge_id).call
      end

      # Calculate all the extra leaderboards in this challenge, with dynamic filtering
      # Assumption: Same challenge would not be having meta leaderboard and extra leaderboards
      ChallengeRound.find(challenge_round_id).challenge.challenge_leaderboard_extras.each do |challenge_leaderboard_extra|
        ChallengeRounds::CreateLeaderboardsService.new(challenge_round: ChallengeRound.find(challenge_round_id), challenge_leaderboard_extra: challenge_leaderboard_extra).call
      end
    end
    Notification::LeaderboardNotificationJob.perform_now(challenge_round_id)
  end
end
