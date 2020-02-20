class CreateParticipantOrganizers < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_organizers do |t|
      t.references :participant, foreign_key: true
      t.references :organizer, foreign_key: true

      t.timestamps
    end
    add_index :participant_organizers, [:participant_id , :organizer_id], unique: true
  end
end
