class OngoingLeaderboardPolicy < LeaderboardPolicy
  class Scope
    attr_reader :participant, :scope

    def initialize(participant, scope)
      @participant = participant
      @scope       = scope
    end

    def participant_sql(participant)
      if participant.present?
        participant_id       = participant.id
        email                = participant.email
        participant_team_ids = participant.teams.pluck(:id).join(',')
        team_check = "OR (submitter_type = 'Team' AND submitter_id IN (#{participant_team_ids}))" if participant_team_ids.present?
        <<~SQL
          (submitter_type = 'Participant' AND submitter_id = #{participant_id})
          #{team_check}
          OR ongoing_leaderboards.challenge_id IN
            (SELECT c.id
              FROM challenges c
              WHERE c.show_leaderboard IS TRUE
              AND c.private_challenge IS FALSE
            UNION
             SELECT c.id
              FROM challenges c
              WHERE c.show_leaderboard IS TRUE
              AND c.private_challenge IS TRUE
              AND EXISTS (SELECT 'X'
                FROM invitations
                WHERE invitations.challenge_id = c.id
                AND invitations.email = '#{email}'
              )
            )
        SQL
      else
        participant_id = 0
        "ongoing_leaderboards.submitter_type = 'Participant' AND ongoing_leaderboards.submitter_id = #{participant_id} OR ongoing_leaderboards.challenge_id IN (SELECT c.id FROM challenges c WHERE c.show_leaderboard IS TRUE AND c.private_challenge IS FALSE UNION SELECT c.id FROM challenges c WHERE c.show_leaderboard IS TRUE  AND c.private_challenge IS TRUE)"
      end
    end

    def resolve
      DefaultScopeByRoleQuery.new(
        participant:     participant,
        participant_sql: participant_sql(participant),
        relation:        scope
      ).call
    end
  end
end
