class AddBannerFileToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :banner_file, :string
  end
end
