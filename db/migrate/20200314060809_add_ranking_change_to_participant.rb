class AddRankingChangeToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :ranking_change, :integer, null: false, default: 0
  end
end
