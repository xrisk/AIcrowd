class ParticipantRatingRanksQuery
  attr_reader :relation

  def initialize(relation = Participant.all)
    @relation = relation
  end

  def participants_with_ranks()
    # this query joins leaderboard with team participants if the submission is a team based submission, or else with the individual
    # participants, then it calls for rating and variation fields, whenever rating from a team based user is not available, it searches
    # for a rating from a participant based submission and if even a participant based submission is not available it then uses 0 as default
    # Also, for temporary fields we take permanent rating as default value whenever a temporary rating is not available.
    @relation = @relation.where('rating is not null').select('slug, name, rating, rank() over (order by rating desc) as ranking').reorder('ranking asc')
  end

end
