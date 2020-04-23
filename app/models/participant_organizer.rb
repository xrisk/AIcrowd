class ParticipantOrganizer < ApplicationRecord
  belongs_to :participant
  belongs_to :organizer
  validates :organizer_id, uniqueness: { scope: :participant_id }

  after_commit :add_participant_to_discourse_groups, on: :create

  private

  def add_participant_to_discourse_groups
    return if Rails.env.development? || Rails.env.test?

    organizer.challenges.draft_or_private.find_each do |challenge|
      Discourse::AddUsersToGroupJob.perform_later(challenge, [participant])
    end
  end
end
