class RemovePrimarySortOrderCdAndSecondarySortOrderCdFromChallenges < ActiveRecord::Migration[5.2]
  def change
    remove_column :challenges, :primary_sort_order_cd, :string, default: 'ascending'
    remove_column :challenges, :secondary_sort_order_cd, :string, default: 'not_used'
  end
end
