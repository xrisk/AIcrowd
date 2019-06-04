class TeamInvitation < ApplicationRecord
  STATUSES = [:pending_send, :pending_response, :accepted, :rejected, :canceled].freeze

  belongs_to :team, inverse_of: :team_invitations
  belongs_to :invitor, class_name: 'Participant', inverse_of: :invitor_team_invitations
  belongs_to :invitee, class_name: 'Participant', inverse_of: :invitee_team_invitations

  as_enum :status, STATUSES, map: :string, source: :status, prefix: true

  validates_inclusion_of :status, in: STATUSES
end
