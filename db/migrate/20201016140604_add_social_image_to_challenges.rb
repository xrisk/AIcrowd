class AddSocialImageToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :social_media_image_file, :string
  end
end
