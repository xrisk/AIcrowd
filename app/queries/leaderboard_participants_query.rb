class LeaderboardParticipantsQuery
  def initialize(relation = Leaderboard.all)
    @relation = relation
  end

  def call(challenge_round, temporary)
    # this query joins leaderboard with team participants if the submission is a team based submission, or else with the individual
    # participants, then it calls for rating and variation fields, whenever rating from a team based user is not available, it searches
    # for a rating from a participant based submission and if even a participant based submission is not available it then uses 0 as default
    # Also, for temporary fields we take permanent rating as default value whenever a temporary rating is not available.
    @relation = @relation
                .joins("left outer join team_participants tp on (tp.team_id=submitter_id and submitter_type='Team')")
                .joins('left outer join participants p on tp.participant_id=p.id')
                .joins("left outer join participants p2 on (p2.id=submitter_id and submitter_type='Participant')")
                .where("challenge_round_id = #{challenge_round}")
    if temporary
      @relation.select("seq, coalesce(p.id, p2.id) as participant_id,
                 ROUND(coalesce(p.temporary_rating, p2.temporary_rating, p.rating, p2.rating, 0)::numeric, 5) as participant_rating,
                 ROUND(coalesce(p.temporary_variation, p2.temporary_variation, p.variation, p2.variation, 0)::numeric, 5) as participant_variation")
    else
      @relation.select("seq, coalesce(p.id, p2.id) as participant_id,
                 ROUND(coalesce(p.rating, p2.rating, 0)::numeric, 5) as participant_rating,
                 ROUND(coalesce(p.variation, p2.variation, 0)::numeric, 5) as participant_variation")
    end
  end
end
