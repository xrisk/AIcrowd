namespace :participant_associative do
  desc "destroy participant associative records if participant not exists anymore"
  print 'destroying...'
  task destroy: :environment do
    team_participants = TeamParticipant.all
    team_participant_invitees = TeamInvitation.where(invitee_type: 'Participant')
    participant_badges = AicrowdUserBadge.all
    all_participants = Participant.all

    team_participants.each do |team_participant|
      team_participant.destroy unless all_participants.include?(team_participant.participant)
    end

    team_participant_invitees.each do |participant_invitee|
      participant_invitee.destroy unless all_participants.include?(participant_invitee.invitee)
    end

    participant_badges.each do |participant_badge|
      participant_badge.destroy unless all_participants.include?(participant_badge.participant)
    end
  end
end
