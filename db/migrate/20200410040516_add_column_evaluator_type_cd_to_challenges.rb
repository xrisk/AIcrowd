class AddColumnEvaluatorTypeCdToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :evaluator_type_cd, :string
  end
end
