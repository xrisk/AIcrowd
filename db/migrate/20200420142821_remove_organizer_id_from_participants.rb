class RemoveOrganizerIdFromParticipants < ActiveRecord::Migration[5.2]
  def change
    remove_column :participants, :organizer_id
  end
end
