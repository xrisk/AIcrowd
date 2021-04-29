class CreateBaselines < ActiveRecord::Migration[5.2]
  def change
    create_table :baselines do |t|
      t.integer :challenge_id, null: false
      t.text :git_url, null: false
      t.boolean :default, default: false
      t.timestamps
    end
  end
end
