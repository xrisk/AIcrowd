class AddBannerToSetting < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :banner_text, :string, default: 'We are Hiring!'
    add_column :settings, :banner_color, :string, default: '#F0524D'
    add_column :settings, :enable_banner, :boolean, default: false
    add_column :settings, :footer_text, :text
    add_column :settings, :enable_footer, :boolean, default: false
  end
end
