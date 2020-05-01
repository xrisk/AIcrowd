class AddPracticeFlagToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :practice_flag, :boolean, null: false, default: false
  end
end
