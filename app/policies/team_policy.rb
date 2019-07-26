class TeamPolicy < ApplicationPolicy
  def show?
    true
  end

  # only the team organizer can invite new members
  def create_invitations?
    record.team_participants_organizer.exists?(participant_id: participant&.id)
  end

  # only the team organizer can cancel invitations to new members
  def cancel_invitations?
    @cancel_invitations ||= record.team_participants_organizer.exists?(participant_id: participant&.id)
  end

  # only team members can see who else is invited
  def show_invitations?
    record.team_participants.exists?(participant_id: participant&.id)
  end
end
