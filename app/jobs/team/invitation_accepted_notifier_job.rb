class Team::InvitationAcceptedNotifierJob < ApplicationJob
  queue_as :default

  def perform(invitee_id, mails)
    TeamInvitation\
      .where(id: mails[:accepted_invitations])
      .includes(team: { team_participants_organizer: :participant })
      .each do |inv|
        inv.team.team_participants_organizer.each do |tp|
          Team::Organizer::InvitationAcceptedNotificationMailer.new.sendmail(tp.participant, inv)
        end
        Team::Invitee::InvitationAcceptedNotificationMailer.new.sendmail(inv)
      end

    TeamInvitation\
      .where(id: mails[:declined_invitations])
      .includes(team: { team_participants_organizer: :participant })
      .each do |inv|
        inv.team.team_participants_organizer.each do |tp|
          Team::Organizer::InvitationDeclinedNotificationMailer.new.sendmail(tp.participant, inv)
        end
      end

    canceled = Hash[mails[:canceled_invitations].map { |x| [x.delete(:invitee_id), x] }]
    Participant.where(id: canceled.keys).each do |participant|
      obj = canceled[participant.id]
      Team::Invitee::InvitationCanceledNotificationMailer.new.sendmail(participant, obj[:team_name])
    end
  end
end
