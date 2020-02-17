class AddParticipantOrganizer < ActiveRecord::Migration[5.2]
  def change
    participants = Participant.where.not(organizer_id: nil)
    participants.each do |participant|
      ParticipantOrganizer.create(participant_id: participant.id,
                                  organizer_id: participant.organizer_id)
    end
  end
end
