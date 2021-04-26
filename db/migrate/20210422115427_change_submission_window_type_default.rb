class ChangeSubmissionWindowTypeDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :challenges, :submission_window_type_cd, 'fixed_window'
  end
end
