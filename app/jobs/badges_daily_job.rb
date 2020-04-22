class BadgesDailyJob < ApplicationJob
  queue_as :default
  def badges_addition_condition(params, during_badge, participant_ranks, participant_id)
    if participant_ranks < params[0]
      Participant.find_by(id: participant_id).add_badge(3 + during_badge)
    elsif participant_ranks < params[1]
      Participant.find_by(id: participant_id).add_badge(2 + during_badge)
    elsif participant_ranks < params[2]
      Participant.find_by(id: participant_id).add_badge(1 + during_badge)
    end
  end

  def apply_badges(teams_participant_ids, during_badge, ranks, max_rank)
    teams_participant_ids.each_with_index do |team, i|
      team.each_with_index do |participant_id, j|
        participant_ranks = ranks[i].to_f/max_rank.to_f
        if max_rank <= 250
          badges_addition_condition([0.1, 0.2, 0.4], during_badge, participant_ranks, participant_id)
        elsif max_rank > 250
          badges_addition_condition([0.01, 0.05, 0.1], during_badge, participant_ranks, participant_id)
        end
      end
    end
  end

  def assign_badges_to_challenge(round_id)
    user_rating_service = UserRatingService.new(round_id)
    leaderboard_rating_stats = user_rating_service.leaderboard_query
    ranks, teams_mu, teams_sigma, teams_participant_ids = user_rating_service.filter_leaderboard_stats leaderboard_rating_stats
    max_rank = ranks.last
    during_badge = 0
    if user_rating_service.temporary
      during_badge = 3
    else
      apply_badges(teams_participant_ids, during_badge, ranks, max_rank)
      user_rating_service.round.update(assigned_permanent_badge: true)
    end
  end

  def perform(*args)
    challenge_rounds = ChallengeRound.where("assigned_permanent_badge=FALSE OR assigned_permanent_badge is NULL").order(end_dttm: :asc).pluck(:id)
    challenge_rounds.each do |round_id|
      assign_badges_to_challenge(round_id)
    end
  end
end
