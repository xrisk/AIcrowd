class AddColumnsToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :rating, :float
    add_column :participants, :temporary_rating, :float
  end
end
