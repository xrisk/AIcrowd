class AddRestrictedIpsToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :restricted_ip, :string
  end
end
