class AddSubmmissionTypeToChallengeRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :submissions_type_cd, :string, null: false, default: 'artifact'
  end
end
