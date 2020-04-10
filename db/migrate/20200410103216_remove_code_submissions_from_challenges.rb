class RemoveCodeSubmissionsFromChallenges < ActiveRecord::Migration[5.2]
  def change
    remove_column :challenges, :code_submissions, :boolean
  end
end
