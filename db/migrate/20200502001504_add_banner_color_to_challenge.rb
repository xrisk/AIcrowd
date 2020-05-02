class AddBannerColorToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :banner_color, :string
  end
end
