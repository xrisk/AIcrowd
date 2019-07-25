class Team::InvitationAcceptedNotifierJob < ApplicationJob
  queue_as :default

  def perform(invitee_id, mails)
    Team.where(id: mails[:accepted_invitations]).includes(:team_participant_organizers).each do |team|
      team.team_participant_organizers.each do |tp|
        Team::Organizer::InvitationAcceptedNotificationMailer.new.sendmail(
          participant_id: tp.participant_id,
          team_id: team.id,
          invitee_id: invitee_id,
        )
      end
      Team::Invitee::InvitationAcceptedNotificationMailer.new.sendmail(
        participant_id: invitee_id,
        team_id: team.id,
      )
    end

    Team.where(id: mails[:declined_invitations]).includes(:team_participant_organizers).each do |team|
      team.team_participant_organizers.each do |tp|
        Team::Organizer::InvitationDeclinedNotificationMailer.new.sendmail(
          participant_id: tp.participant_id,
          team_id: team.id,
          invitee_id: invitee_id,
        )
      end
    end

    mails[:canceled_invitations].each do |rescission|
      Team::Invitee::InvitationCanceledNotificationMailer.new.sendmail(
        participant_id: rescission[:invitee_id],
        team_name: rescission[:team_name],
        rescinder_id: invitee_id,
      )
    end
  end
end
