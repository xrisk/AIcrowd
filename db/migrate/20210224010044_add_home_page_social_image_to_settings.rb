class AddHomePageSocialImageToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :home_page_social_image, :string
  end
end
