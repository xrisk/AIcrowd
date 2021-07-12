class AddMixpanelDoneToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :mixpanel_done, :boolean, default: false
  end
end
