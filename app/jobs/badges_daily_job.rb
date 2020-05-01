class BadgesDailyJob < ApplicationJob
  queue_as :default

  def perform(*args)
    challenge_rounds = ChallengeRound.where("assigned_permanent_badge=FALSE OR assigned_permanent_badge is NULL").order(end_dttm: :asc).pluck(:id)
    challenge_rounds.each do |round_id|
      user_rating_service = UserRatingService.new(round_id)
      if !user_rating_service.temporary
        leaderboard_rating_stats = user_rating_service.leaderboard_query
        ranks, teams_mu, teams_sigma, teams_participant_ids = user_rating_service.filter_leaderboard_stats leaderboard_rating_stats
        max_rank = ranks.last
        teams_participant_ids.each_with_index do |team, i|
          team.each_with_index do |participant_id, j|
            participant_ranks = ranks[i].to_f/max_rank.to_f
            for badge in AicrowdBadge.where(badges_event_id: BadgesEvent.where(name: "dailychallenge").pluck(:id))
              eval(badge.code)
            end
          end
        end
      end
        user_rating_service.round.update!(assigned_permanent_badge: true)
      end
  end
end
