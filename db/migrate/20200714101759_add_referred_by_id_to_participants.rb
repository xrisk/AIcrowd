class AddReferredByIdToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :referred_by_id, :bigint, index: true
  end
end
