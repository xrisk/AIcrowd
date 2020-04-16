class AddTabularOverviewToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :scrollable_overview_tabs, :boolean, null: false, default: true
  end
end
