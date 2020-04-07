class AddCodeDataToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :code_data, :string
  end
end
