class AddTrustedColumnToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :trusted, :boolean, default: false
  end
end
