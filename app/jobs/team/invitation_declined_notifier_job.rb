class Team::InvitationDeclinedNotifierJob < ApplicationJob
  queue_as :default

  def perform(invitation_id)
    inv = TeamInvitation.find(invitation_id)
    inv.team.team_participants_organizer.each do |tp|
      Organizers::InvitationsMailer.declined_notification_email(tp.participant, inv).deliver_now
    end
  end
end
