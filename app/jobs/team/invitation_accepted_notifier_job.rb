class Team::InvitationAcceptedNotifierJob < ApplicationJob
  queue_as :default

  def perform(_invitee_id, mails)
    TeamInvitation\
      .where(id: mails[:accepted_invitations])
      .includes(team: { team_participants_organizer: :participant })
      .each do |inv|
        inv.team.team_participants_organizer.each do |tp|
          Organizers::InvitationsMailer.accepted_notification_email(tp.participant, inv).deliver_now
        end
        Participants::InvitationsMailer.invitation_accepted_email(inv).deliver_now
      end

    TeamInvitation\
      .where(id: mails[:declined_invitations])
      .includes(team: { team_participants_organizer: :participant })
      .each do |inv|
        inv.team.team_participants_organizer.each do |tp|
          Organizers::InvitationsMailer.declined_notification_email(tp.participant, inv).deliver_now
        end
      end

    canceled = Hash[mails[:canceled_invitations].map { |x| [x[:invitation][:invitee_id], x] }]
    Participant.where(id: canceled.keys).each do |participant|
      # replace id with instance to avoid re-loading it in the mailer
      data     = canceled[participant.id].deep_merge({ invitation: { invitee_id: nil, invitee: participant } })
      # mock instances because the invitation and team no longer exist
      inv      = TeamInvitation.new(data[:invitation])
      inv.team = Team.new(data[:team])
      Participants::InvitationsMailer.invitation_canceled_email(inv).deliver_now
    end
  end
end
