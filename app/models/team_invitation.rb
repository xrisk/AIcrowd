class TeamInvitation < ApplicationRecord
  STATUSES = [
    :pending,  # invitation sending/sent, but no action taken yet
    :accepted, # invitee accepted and became a team member
    :declined, # invitee declined and did not become a team member
    :canceled, # the invitee will not become a member because the organizer rescinded the invitation
  ].freeze

  after_initialize :init_uuid, if: :new_record?

  belongs_to :team, inverse_of: :team_invitations
  belongs_to :invitor, class_name: 'Participant', inverse_of: :invitor_team_invitations
  belongs_to :invitee, class_name: 'Participant', inverse_of: :invitee_team_invitations

  as_enum :status, STATUSES, map: :string, source: :status, prefix: true

  validates_inclusion_of :status, in: STATUSES
  validates_uniqueness_of :uuid

  def to_param
    uuid
  end

  def init_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
