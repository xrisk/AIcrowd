class AddEditorsSelectionToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :editors_selection, :boolean, null: false, default: false
  end
end
