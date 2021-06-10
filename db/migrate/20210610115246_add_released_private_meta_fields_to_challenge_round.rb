class AddReleasedPrivateMetaFieldsToChallengeRound < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :released_private_meta_fields, :text
  end
end
