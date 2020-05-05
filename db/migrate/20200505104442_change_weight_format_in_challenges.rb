class ChangeWeightFormatInChallenges < ActiveRecord::Migration[5.2]
  def change
    change_column :challenges, :weight, :float
  end
end
