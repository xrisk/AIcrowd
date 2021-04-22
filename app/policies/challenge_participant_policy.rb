class ChallengeParticipantPolicy < ChallengePolicy
  def update?
    participant && (participant.admin? || @record.participant_id == participant.id)
  end

  class Scope
    attr_reader :participant, :scope

    def initialize(participant, scope)
      @participant = participant
      @scope       = scope
    end

    def participant_sql(email:)
      %[
        (select challenges.id from challenges where
        challenges.status_cd IN ('running','completed','starting_soon')
        AND challenges.private_challenge IS FALSE
        OR (challenges.private_challenge IS TRUE
            AND EXISTS (SELECT 'X'
                    FROM invitations
                    WHERE invitations.challenge_id = challenges.id
                    AND invitations.email = '#{email}')))
      ]
    end

    def resolve
      if participant&.admin?
        scope.all
      else
        if participant&.organizers&.any?
          scope.left_joins(challenge: :organizers)
            .where("challenges.status_cd IN ('running','completed','starting_soon') OR organizers.id IN (#{participant.organizer_ids.join(',')})")
            .distinct
        elsif participant
          scope.where("challenge_id IN #{participant_sql(email: participant.email)}")
        else
          scope.where("challenge_id IN (select challenges.id from challenges where
        challenges.status_cd IN ('running','completed','starting_soon') AND challenges.private_challenge IS FALSE)")
        end
      end
    end
  end
end
