class ChallengesOrganizer < ApplicationRecord
  belongs_to :challenge, class_name: 'Challenge'
  belongs_to :organizer, class_name: 'Organizer'

  validates :organizer_id, uniqueness: { scope: :challenge_id }

  after_commit :add_organizer_to_discourse_group, on: :create
  after_commit :remove_organizer_from_discourse_group, on: :destroy

  private

  def add_organizer_to_discourse_group
    return if Rails.env.development? || Rails.env.test?
    return unless challenge.hidden_in_discourse?

    Discourse::AddUsersToGroupJob.perform_later(challenge.id, organizer.participants.ids)
  end

  def remove_organizer_from_discourse_group
    return if Rails.env.development? || Rails.env.test?

    Discourse::RemoveUsersFromGroupJob.perform_later(challenge.id, organizer.participants.pluck(:name).join(','))
  end
end
