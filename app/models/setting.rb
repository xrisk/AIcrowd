class Setting < ApplicationRecord
  def self.banner_record
    first&.banner_text if first&.enable_banner
  end

  def self.banner_color_value
    first&.banner_color if first&.enable_banner
  end

  def self.footer_record
    first&.footer_text if first&.enable_footer
  end
end
