class CalculateLeaderboardJob < ApplicationJob
  queue_as :default

  def perform(challenge_round_id:)
    # This challenge has custom logic that takes 5 different scores and calculates average of them, thus we cannot recalculate
    # leaderboards records with ChallengeRounds::CreateLeaderboardsService class.
    challenge_round = ChallengeRound.find(challenge_round_id)
    return if challenge_round.challenge.challenge == "NeurIPS 2019 : Disentanglement Challenge"

    if challenge_round.challenge.meta_challenge || challenge_round.challenge.ml_challenge
      challenge_round.challenge_leaderboard_extras.each do |challenge_leaderboard_extra|
        CalculateMetaLeaderboardService.new(challenge_id: challenge_round.challenge.id, challenge_leaderboard_extra: challenge_leaderboard_extra).call
      end
      return
    end

    # Calculate all the leaderboards in this challenge
    challenge_round.challenge_leaderboard_extras.each do |challenge_leaderboard_extra|
      ChallengeRounds::CreateLeaderboardsService.new(challenge_round: challenge_round, challenge_leaderboard_extra: challenge_leaderboard_extra).call
    end


    # Trigger all the leaderboard computations in case this round_id is being used for meta challenge
    ChallengeProblems.where(challenge_round_id: challenge_round_id).each do |challenge_problem|
      challenge_round.challenge_leaderboard_extras.each do |challenge_leaderboard_extra|
        ChallengeRounds::CreateLeaderboardsService.new(challenge_round: challenge_round, meta_challenge_id: challenge_problem.challenge_id, challenge_leaderboard_extra: challenge_leaderboard_extra).call
      end

      challenge_problem.challenge.active_round.challenge_leaderboard_extras.each do |challenge_leaderboard_extra|
        CalculateMetaLeaderboardService.new(challenge_id: challenge_problem.challenge_id, challenge_leaderboard_extra: challenge_leaderboard_extra).call
      end

    end

    Notification::LeaderboardNotificationJob.perform_now(challenge_round_id)
  end
end
