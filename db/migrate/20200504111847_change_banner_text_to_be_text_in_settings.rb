class ChangeBannerTextToBeTextInSettings < ActiveRecord::Migration[5.2]
  def change
    change_column :settings, :banner_text, :text
  end
end
