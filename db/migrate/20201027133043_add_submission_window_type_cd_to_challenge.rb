class AddSubmissionWindowTypeCdToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :submission_window_type_cd, :string, :default => 'rolling_window'
  end
end
