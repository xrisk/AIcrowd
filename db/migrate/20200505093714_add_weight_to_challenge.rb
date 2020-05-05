class AddWeightToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :weight, :integer, default: 0
  end
end
