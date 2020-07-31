class DefaultScopeByRoleQuery
  def initialize(participant:, participant_sql:, relation: Leaderboard)
    @participant     = participant
    @participant_sql = participant_sql
    @relation        = relation
  end

  def call
    if participant&.admin? # Admin role
      relation.all
    elsif participant&.organizers&.any? # Organizer role
      sql = if organizers_challenges_ids.any?
              %[
                #{participant_sql}
                OR challenge_id IN (#{organizers_challenges_ids.join(',')})
              ]
            else
              participant_sql
            end
      relation.where(sql)
    else # Participant role
      relation.where(participant_sql)
    end
  end

  private

  attr_reader :participant, :participant_sql, :relation

  def organizers_challenges_ids
    @challenges_ids ||= Challenge.left_joins(:organizers)
                                 .where("organizers.id IN (#{participant.organizers.pluck(:id).join(',')})")
                                 .group('challenges.id')
                                 .pluck('challenges.id')
  end
end
