class AddEvaluationCriteriaColumnsToChallengeRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :evaluator_type_cd, :string
    add_column :challenge_rounds, :challenge_client_name, :string
    add_column :challenge_rounds, :grader_identifier, :string, default: "AIcrowd_GRADER_POOL"
  end
end
