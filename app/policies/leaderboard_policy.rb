class LeaderboardPolicy < ApplicationPolicy
  def index?
    true
  end

  def host?
    true
  end

  def submission_detail?
    participant &&
      (participant.admin? ||
          @record.participant_id == participant.id ||
          ChallengeOrganizerParticipant.where(
            participant_id: participant.id,
            id:             @record.challenge_id
          ).present?
      )
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
      if participant&.admin?
        scope.all
      else
        if participant&.organizers&.any?
          challenges_ids = Challenge.left_joins(:organizers)
                             .where("organizers.id IN (#{participant.organizers.pluck(:id).join(',')})")
                             .group('challenges.id')
                             .pluck('challenges.id')

          sql = if challenges_ids.any?
                  %[
                    #{participant_sql(participant)}
                    OR challenge_id IN (#{challenges_ids.join(',')})
                  ]
                else
                  participant_sql(participant)
                end
          scope.where(sql)
        else
          scope.where(participant_sql(participant))
        end
      end
    end
  end
end
