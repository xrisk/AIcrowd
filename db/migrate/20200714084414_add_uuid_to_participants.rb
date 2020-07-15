class AddUuidToParticipants < ActiveRecord::Migration[5.2]
  def up
    enable_extension 'pgcrypto'
    add_column :participants, :uuid, :uuid, null: false, default: 'gen_random_uuid()'
    add_index :participants, :uuid, unique: true
  end


  def down
    disable_extension 'pgcrypto'
    remove_column :participants, :uuid, :uuid, null: false, default: 'gen_random_uuid()'
  end
end
