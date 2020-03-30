class ParticipantRatingRanksQuery
  attr_reader :relation

  def initialize(relation = Participant.all)
    @relation = relation
  end

  def call()
    ranks = @relation.where('rating is not null').select('id, rank() over (order by rating desc) as current_ranking, ranking as previous_ranking, ranking_change').reorder('ranking asc')
    participant_rankings = ranks.map {|participant| {ranking: participant.current_ranking}}
    participant_rankings_change = ranks.map do |participant|
      change_in_true_ranking = participant.current_ranking - participant.previous_ranking
      if participant.previous_ranking == -1
        {'ranking_change' => 0}
      elsif  change_in_true_ranking.to_i == 0
        {'ranking_change' => participant.ranking_change.to_i}
      else
        {'ranking_change' => change_in_true_ranking.to_i}
      end
    end
    participant_ids = ranks.map {|participant| participant.id}
    Participant.update participant_ids, participant_rankings
    Participant.update participant_ids, participant_rankings_change
  end
end
