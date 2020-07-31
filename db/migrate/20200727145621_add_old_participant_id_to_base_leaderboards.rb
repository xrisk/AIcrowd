class AddOldParticipantIdToBaseLeaderboards < ActiveRecord::Migration[5.2]
  def change
    add_column :base_leaderboards, :old_participant_id, :bigint
  end
end
