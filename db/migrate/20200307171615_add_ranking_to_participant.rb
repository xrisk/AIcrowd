class AddRankingToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :ranking, :integer, :null => false, :default => -1
  end
end
