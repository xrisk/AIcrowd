class RemoveOrganizerIdFromChallenges < ActiveRecord::Migration[5.2]
  def change
    remove_column :challenges, :organizer_id
  end
end
