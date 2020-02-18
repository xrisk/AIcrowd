class AddParticipantOrganizer < ActiveRecord::Migration[5.2]
  def change
    # move existing data of participant's organizer_id into middle table (ParticipantOrganizer)
    participants = Participant.where.not(organizer_id: nil)
    participants.each do |participant|
      ParticipantOrganizer.create(participant_id: participant.id,
                                  organizer_id: participant.organizer_id)
    end
  end
end
