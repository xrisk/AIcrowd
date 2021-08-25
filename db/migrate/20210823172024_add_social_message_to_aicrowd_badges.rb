class AddSocialMessageToAicrowdBadges < ActiveRecord::Migration[5.2]
  def change
    add_column :aicrowd_badges, :social_message, :text
  end
end
