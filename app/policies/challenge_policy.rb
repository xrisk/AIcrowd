class ChallengePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    ChallengePolicy::Scope.new(participant, Challenge).resolve.include?(@record)
  end

  def edit?
    participant && (participant.admin? || (participant.organizer_ids & @record.organizer_ids).any?)
  end

  def reorder?
    participant&.admin?
  end

  def assign_order?
    participant&.admin?
  end

  def update?
    edit?
  end

  def new?
    participant && (participant.admin? || (participant.organizer_ids & @record.organizer_ids).any?)
  end

  def api_create?
    participant && (participant.organizers.any? || participant.admin?)
  end

  def create?
    new?
  end

  def destroy?
    edit?
  end

  def regrade?
    edit?
  end

  def regen_api_key?
    update?
  end

  def remove_image?
    update?
  end

  def remove_banner?
    update?
  end

  def remove_invited?
    update?
  end

  def clef_task?
    update?
  end

  def export?
    update?
  end

  def import?
    create?
  end

  def leaderboard_public?
    @record.show_leaderboard == true
  end

  def show_leaderboard?
    return false if starting_soon_mode?
    return false unless @record.challenge_rounds.present?

    leaderboard_public? || edit?
  end

  def show_submissions?
    return false if starting_soon_mode?

    @record.submissions_page.present? || edit?
  end

  def show_winners?
    return false if starting_soon_mode?

    @record.winners_tab_active.present?
  end

  def starting_soon_mode?
    @record.status == :starting_soon
  end

  def has_accepted_challenge_rules?
    @record.has_accepted_challenge_rules?(participant)
  end

  def has_accepted_participation_terms?
    return unless participant

    participant.has_accepted_participation_terms?
  end

  def submissions_allowed?
    return false unless @record.online_submissions
    return true if edit?
    return false if @record.starting_soon? || @record.draft?

    return false if @record.completed? && !@record.post_challenge_submissions?

    # Return false if the challenge is set to "running" but there is no active round
    # or the active round start time is in the future
    return false if Time.zone.now.to_i < @record.start_dttm.to_i

    # If we reach this part that means that the challenge status is set to 'running'
    # return true if not a clef challenge
    return true unless @record.clef_challenge.present?

    # return true if a clef challenge and participant is registered
    return true if @record.clef_challenge.present? && clef_participant_registered?(@record)

    false # no positive condition met
  end

  def clef_participant_registered?(challenge)
    return false unless participant.present?

    clef_task             = challenge.clef_task
    participant_clef_task = ParticipantClefTask.where(
      participant_id: participant,
      clef_task_id:   clef_task.id
    ).first
    if participant_clef_task
      return true if participant_clef_task.registered?
    else
      false
    end
  end

  def create_team?(out_issues_hash = nil)
    cached_with_issues(:create_team?, out_issues_hash) do
      {
        not_allowed:
                                   !record.teams_allowed?,
        participant_not_logged_in:
                                   participant.nil?,
        challenge_not_running:
                                   !record.running?,
        challenge_teams_frozen:
                                   record.teams_frozen?,
        team_exists:
                                   participant.teams.exists?(challenge_id: record.id)
      }
    end
  end

  class Scope
    attr_reader :participant, :scope

    def initialize(participant, scope)
      @participant = participant
      @scope       = scope
    end

    def participant_sql(email:)
      %[
        challenges.status_cd IN ('running','completed','starting_soon')
        AND challenges.private_challenge IS FALSE
        OR (challenges.private_challenge IS TRUE
            AND EXISTS (SELECT 'X'
                    FROM invitations
                    WHERE invitations.challenge_id = challenges.id
                    AND invitations.email = '#{email}'))
      ]
    end

    def resolve
      if participant&.admin?
        scope.all
      else
        if participant&.organizers.present?
          scope.left_joins(:organizers)
               .where("status_cd IN ('running','completed','starting_soon') OR organizers.id IN (#{participant.organizer_ids.join(',')})")
               .group('challenges.id')
        elsif participant
          scope.where(participant_sql(email: participant.email))
        else
          scope.where("status_cd IN ('running','completed','starting_soon') AND challenges.private_challenge IS FALSE")
        end
      end
    end
  end
end
