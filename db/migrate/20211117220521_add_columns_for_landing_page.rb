class AddColumnsForLandingPage < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :feature_challenge_1, :boolean, default: false
    add_column :challenges, :feature_challenge_2, :boolean, default: false
    add_column :challenges, :feature_challenge_3, :boolean, default: false
    add_column :posts, :featured, :boolean, default: false
  end
end
