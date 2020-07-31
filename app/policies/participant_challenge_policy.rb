class ParticipantChallengePolicy < ApplicationPolicy
  def index?
    participant
  end

  class Scope
    attr_reader :participant, :scope

    def initialize(participant, scope)
      @participant = participant
      @scope       = scope
    end

    def participant_sql(email:)
      %[
        participant_challenges.status_cd IN ('running','completed','starting_soon')
        AND participant_challenges.private_challenge IS FALSE
        OR (participant_challenges.private_challenge IS TRUE
            AND EXISTS (SELECT 'X'
                    FROM invitations
                    WHERE invitations.challenge_id = participant_challenges.id
                    AND invitations.email = '#{email}'))
      ]
    end

    def resolve
      if participant&.admin?
        scope.all
      else
        if participant&.organizers&.any?
          scope.left_joins(challenge: :organizers)
               .where("participant_challenges.status_cd IN ('running','completed','starting_soon') OR organizers.id IN (#{participant.organizer_ids.join(',')})")
               .distinct
        elsif participant
          scope.where(participant_sql(email: participant.email))
        else
          scope.where("status_cd IN ('running','completed','starting_soon') AND participant_challenges.private_challenge IS FALSE")
        end
      end
    end
  end
end
