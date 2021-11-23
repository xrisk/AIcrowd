class AddColumnLandingCardPrize < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :landing_card_prize, :text
  end
end
