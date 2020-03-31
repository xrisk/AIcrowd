class AddCodeSubmissionsToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :code_submissions, :boolean, default: false
  end
end
