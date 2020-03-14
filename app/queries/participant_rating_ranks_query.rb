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
    @relation.where('rating is not null and ranking > 0').select('slug, name, rating, variation, created_at, ranking, ranking_change').reorder('ranking asc')
  end

  def participants_ranks_update()
    ranks = @relation.where('rating is not null').select('id, rank() over (order by rating desc) as current_ranking, ranking as previous_ranking, ranking_change').reorder('ranking asc')
    participant_rankings = ranks.map {|participant| {'ranking' => participant.current_ranking}}
    participant_rankings_change = ranks.map do |participant|
      change_in_true_ranking = participant.current_ranking - participant.previous_ranking
      if participant.previous_ranking == -1
        {'ranking_change' => 0}
      elsif  change_in_true_ranking == 0
        {'ranking_change' => participant.ranking_change}
      else
        {'ranking_change' => change_in_true_ranking}
      end
    end
    participant_ids = ranks.map {|participant| participant.id}
    Participant.update participant_ids, participant_rankings
    Participant.update participant_ids, participant_rankings_change
  end
  def participants_count()
    @relation.count
  end
  def user_position_participants(current_participant)
    if current_participant.present? || current_participant.ranking != -1
      @relation.where("ranking < #{current_participant.ranking + 3} and ranking > #{current_participant.ranking - 3}").select('slug, name, rating, variation, created_at, ranking').reorder('ranking asc')
    end
  end
end
