class ChallengeParticipant < ApplicationRecord
  belongs_to :challenge
  belongs_to :participant, optional: true
  belongs_to :clef_task, optional: true

  after_commit :add_participant_to_discourse_group, on: :create
  after_commit :remove_participant_from_discourse_group, on: :destroy

  private

  def add_participant_to_discourse_group
    return if Rails.env.development? || Rails.env.test?
    return unless challenge.hidden_in_discourse?

    Discourse::AddUsersToGroupJob.perform_later(challenge.id, [participant.id])
  end

  def remove_participant_from_discourse_group
    return if Rails.env.development? || Rails.env.test?

    Discourse::RemoveUsersFromGroupJob.perform_later(challenge.id, participant.name)
  end
end
