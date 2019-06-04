class TeamPolicy < ApplicationPolicy
  def show?
    true
  end

  # only the team organizer can invite new members
  def create_invitations?
    record.team_participants.find_by(participant_id: participant&.id)&.role == :organizer
  end

  # only team members can see who else is invited
  def show_invitations?
    record.team_participants.exists?(participant_id: participant&.id)
  end
end
