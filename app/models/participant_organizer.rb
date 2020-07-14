class ParticipantOrganizer < ApplicationRecord
  belongs_to :participant
  belongs_to :organizer
  validates :participant_id, uniqueness: { scope: :organizer_id }

  after_commit :add_participant_to_discourse_groups, on: :create
  after_commit :remove_participant_from_discourse_group, on: :destroy

  private

  def add_participant_to_discourse_groups
    return if Rails.env.development? || Rails.env.test?

    organizer.challenges.draft_or_private.find_each do |challenge|
      Discourse::AddUsersToGroupJob.perform_later(challenge.id, [participant.id])
    end
  end

  def remove_participant_from_discourse_group
    return if Rails.env.development? || Rails.env.test?

    organizer.challenges.find_each do |challenge|
      Discourse::RemoveUsersFromGroupJob.perform_later(challenge.id, participant.name)
    end
  end
end
