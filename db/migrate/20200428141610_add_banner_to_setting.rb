class AddBannerToSetting < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :banner_text, :string, null: false, default: 'We are Hiring!'
    add_column :settings, :banner_color, :string, null: false, default: '#F0524D'
  end
end
