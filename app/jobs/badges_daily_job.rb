class BadgesDailyJob < ApplicationJob
  queue_as :default
  def assign_badges_to_challenge(round_id)
    user_rating_service = UserRatingService.new(round_id)
    leaderboard_rating_stats = user_rating_service.leaderboard_query
    ranks, teams_mu, teams_sigma, teams_participant_ids = user_rating_service.filter_leaderboard_stats leaderboard_rating_stats
    max_rank = ranks.last
    participant_ids, participant_ranks  = [], []
    during_badge = 0
    if user_rating_service.temporary
      during_badge = 3
    end
    teams_participant_ids.each_with_index do |team, i|
      team.each_with_index do |participant_id, j|
        participant_ranks = ranks[i].to_f/max_rank.to_f
        if max_rank <= 250
          if participant_ranks < 0.1
            Participant.find_by(id: participant_id).add_badge(3 + during_badge)
          elsif participant_ranks < 0.2
            Participant.find_by(id: participant_id).add_badge(2 + during_badge)
          elsif participant_ranks < 0.4
            Participant.find_by(id: participant_id).add_badge(1 + during_badge)
          end
        elsif max_rank > 250
          if participant_ranks < 0.01
            Participant.find_by(id: participant_id).add_badge(3 + during_badge)
          elsif participant_ranks < 0.05
            Participant.find_by(id: participant_id).add_badge(2 + during_badge)
          elsif participant_ranks < 0.1
            Participant.find_by(id: participant_id).add_badge(1 + during_badge)
          end
        end
      end
    end
    unless user_rating_service.temporary
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
