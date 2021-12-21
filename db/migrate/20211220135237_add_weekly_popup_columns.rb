class AddWeeklyPopupColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :weekly_popup_title, :text
    add_column :settings, :weekly_popup_subtitle, :text
    add_column :settings, :weekly_popup_description, :text
    add_column :settings, :weekly_popup_link, :text
    add_column :settings, :weekly_popup_button, :text
    add_column :settings, :weekly_popup_start_date, :datetime
    add_column :settings, :weekly_popup_end_date, :datetime
  end
end
