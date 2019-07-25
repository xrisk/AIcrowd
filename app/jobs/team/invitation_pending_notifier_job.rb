class Team::InvitationAcceptedNotifierJob < ApplicationJob
  queue_as :default

  def perform(invitation_id)
    Team::Invitee::InvitationPendingNotificationMailer.new.sendmail(
      TeamInvitation.find(invitation_id)
    )
  end
end
