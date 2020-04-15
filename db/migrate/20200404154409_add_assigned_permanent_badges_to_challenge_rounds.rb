class AddAssignedPermanentBadgesToChallengeRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :assigned_permanent_badge, :boolean, default: false, null: false
  end
end
