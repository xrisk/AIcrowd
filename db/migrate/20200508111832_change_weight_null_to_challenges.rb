class ChangeWeightNullToChallenges < ActiveRecord::Migration[5.2]
  def change
    change_column_null :challenges, :weight, false
  end
end
