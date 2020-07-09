class AddChallengeClientNameToChallengeRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :challenge_client_name, :string
  end
end
