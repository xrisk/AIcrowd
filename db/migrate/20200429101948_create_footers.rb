class CreateFooters < ActiveRecord::Migration[5.2]
  def change
    create_table :footers do |t|
      t.text :body, null: false

      t.timestamps
    end
  end
end
