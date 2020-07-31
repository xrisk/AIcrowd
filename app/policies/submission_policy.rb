class SubmissionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    challenge = @record.challenge
    return true if challenge.show_leaderboard.present? && challenge.submissions_page.present? && challenge.private_challenge.blank?

    @record.challenge.submissions_page.present? && (edit? ||
      (@record.challenge.submissions_page.present? && @record.challenge.show_leaderboard.present? &&
        SubmissionPolicy::Scope
          .new(participant, Submission)
          .resolve
          .include?(@record))
                                                   )
  end

  def new?
    ChallengePolicy
      .new(participant, @record.challenge)
      .submissions_allowed?
  end

  def create?
    new?
  end

  def edit?
    participant && (participant.admin? || (participant.organizer_ids & @record.challenge.organizer_ids).any?)
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  class Scope
    attr_reader :participant, :scope

    def initialize(participant, scope)
      @participant = participant
      @scope       = scope
    end

    def participant_sql(participant)
      if participant.present?
        participant_id = participant.id
        email          = participant.email
      else
        participant_id = 0
        email          = nil
      end
      %[
        participant_id = #{participant_id}
        OR submissions.challenge_id IN
          (SELECT c.id
            FROM challenges c
            WHERE c.show_leaderboard IS TRUE
            AND c.private_challenge IS FALSE
          UNION
           SELECT c.id
            FROM challenges c
            WHERE c.show_leaderboard IS TRUE
            AND c.private_challenge IS TRUE
            AND c.status_cd = 'completed'
            AND EXISTS (SELECT 'X'
              FROM invitations
              WHERE invitations.challenge_id = c.id
              AND invitations.email = '#{email}'
            )
          )
        ]
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
