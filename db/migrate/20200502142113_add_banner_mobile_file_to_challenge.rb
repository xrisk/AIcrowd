class AddBannerMobileFileToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :banner_mobile_file, :string
  end
end
