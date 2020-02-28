class CreateChallengesOrganizers < ActiveRecord::Migration[5.2]
  def change
    create_table :challenges_organizers do |t|
      t.references :challenge, null: false, foreign_key: true
      t.references :organizer, null: false, foreign_key: true

      t.timestamps
    end
    add_index :challenges_organizers, [:challenge_id , :organizer_id], unique: true
  end
end
