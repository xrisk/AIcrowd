class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    enable_extension :citext

    create_table :teams do |t|
      t.references :challenge, foreign_key: true
      t.citext :name, null: false
      t.timestamps
      t.index [:name, :challenge_id], unique: true
    end

    create_table :team_participants do |t|
      t.references :team, foreign_key: true
      t.references :participant, foreign_key: true
      t.string :role, default: :member, null: false
      t.timestamps
      t.index [:participant_id, :team_id], unique: true
    end

    create_table :team_invitations do |t|
      t.references :team, foreign_key: true
      t.references :invitor, foreign_key: { to_table: :participants }
      t.references :invitee, foreign_key: { to_table: :participants }
      t.string :status, default: :pending, null: false
      t.timestamps
      t.index [:invitee_id, :team_id], unique: true
    end

    change_table :challenges do |t|
      t.boolean :teams_allowed, default: true, null: false
      t.integer :max_team_participants, default: 5
    end
  end
end
