class AddNewColumnsToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :variation, :float
    add_column :participants, :temporary_variation, :float
  end
end
