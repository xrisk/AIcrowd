class AddPostChallengeSubmissionsToChallengeRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :post_challenge_submissions, :boolean, default: false
  end
end
