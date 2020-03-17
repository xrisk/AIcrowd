namespace :set_organizers_for_participant do
  desc "move existing data of participant's organizer_id into middle table (ParticipantOrganizer)"
  task existing_participant: :environment do
    participants = Participant.where.not(organizer_id: nil)
    participants.each do |participant|
      ParticipantOrganizer.find_or_create_by!(
        participant_id: participant.id,
        organizer_id: participant.organizer_id
      )
    end
  end
end
