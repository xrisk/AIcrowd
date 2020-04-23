class ChallengeParticipant < ApplicationRecord
  belongs_to :challenge
  belongs_to :participant, optional: true
  belongs_to :clef_task, optional: true

  after_commit :add_participant_to_discourse_group, on: :create

  private

  def add_participant_to_discourse_group
    return if Rails.env.development? || Rails.env.test?
    return unless challenge.hidden_in_discourse?

    Discourse::AddUsersToGroupJob.perform_later(challenge, [participant])
  end
end
