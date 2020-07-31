namespace :participant_associative do
  desc 'destroy participant associative records if participant does not exists anymore'
  print 'destroying...'
  task destroy: :environment do
    team_participants         = TeamParticipant.all
    team_participant_invitees = TeamInvitation.where(invitee_type: 'Participant')
    participant_badges        = AicrowdUserBadge.all
    participant_notifications = Notification.all
    team_members              = TeamMember.all

    team_participants.each do |team_participant|
      unless team_participant.participant.present?
        puts "destroying ##{team_participant.id} #{team_participant.role}"
        team_participant.destroy
      end
    end

    team_participant_invitees.each do |participant_invitee|
      unless participant_invitee.invitee.present?
        puts "destroying ##{participant_invitee.id} #{participant_invitee.status}"
        participant_invitee.destroy
      end
    end

    participant_badges.each do |participant_badge|
      unless participant_badge.participant.present?
        puts "destroying ##{participant_badge.id} #{participant_badge.custom_fields}"
        participant_badge.destroy
      end
    end

    participant_notifications.each do |participant_notification|
      unless participant_notification.participant.present?
        puts "destroying ##{participant_notification.id} #{participant_notification.notification_type}"
        participant_notification.destroy
      end
    end

    team_members.each do |team_member|
      unless team_member.participant.present?
        puts "destroying ##{team_member.id} #{team_member.title}"
        team_member.destroy
      end
    end
    print 'Done'
  end
end
