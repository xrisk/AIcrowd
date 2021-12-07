
class AddColumnHomePageSquareImage < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :landing_square_image_file, :string
  end
end
