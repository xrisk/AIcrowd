class ChallengesOrganizer < ApplicationRecord
  belongs_to :challenge, class_name: 'Challenge'
  belongs_to :organizer, class_name: 'Organizer'

  validates :organizer_id, uniqueness: { scope: :challenge_id }

  after_commit :add_organizer_to_discourse_group, on: :create

  private

  def add_organizer_to_discourse_group
    return if Rails.env.development? || Rails.env.test?

    Discourse::AddUsersToGroupJob.perform_later(challenge.id, organizer.participants.ids)
  end
end
