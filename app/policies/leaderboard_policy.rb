class LeaderboardPolicy < ApplicationPolicy
  def index?
    true
  end

  def host?
    true
  end

  def recalculate_leaderboard?
    participant && participant.admin?
  end

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
        team_check           = if participant_team_ids.present?
                                 "OR (submitter_type = 'Team' AND submitter_id IN (#{participant_team_ids}))"
                               else
                                 ''
                     end
      else
        participant_id = 0
        email          = nil
      end
      <<~SQL
        (submitter_type = 'Participant' AND submitter_id = #{participant_id})
        #{team_check}
        OR leaderboards.challenge_id IN
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
