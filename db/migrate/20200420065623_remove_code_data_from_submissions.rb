class RemoveCodeDataFromSubmissions < ActiveRecord::Migration[5.2]
  def change
    remove_column :submissions, :code_data, :text
  end
end
