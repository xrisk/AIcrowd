class AddWeeklyPopupLastShownAtToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :weekly_popup_last_shown_at, :datetime
  end
end
