class CreateRedirects < ActiveRecord::Migration[5.2]
  def change
    create_table :redirects do |t|
      t.string :redirect_url
      t.string :destination_url
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
