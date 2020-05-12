class AddWeightToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :weight, :float, default: 0, null: false
  end
end
