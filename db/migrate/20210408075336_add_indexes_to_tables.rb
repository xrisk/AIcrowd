class AddIndexesToTables < ActiveRecord::Migration[5.2]
  def change
    add_index :base_leaderboards, :challenge_leaderboard_extra_id
    add_index :base_leaderboards, :meta_challenge_id
    add_index :base_leaderboards, :old_participant_id
    add_index :base_leaderboards, :submission_id
    add_index :challenge_leaderboard_extras, :challenge_id
    add_index :challenge_leaderboard_extras, :challenge_round_id
    add_index :challenge_participants, :clef_task_id
    add_index :challenge_problems, :challenge_id
    add_index :challenge_problems, :challenge_round_id
    add_index :challenge_problems, :problem_id
    add_index :challenges, :discourse_category_id
    add_index :challenges, :discourse_group_id
    add_index :challenges, :status_cd
    add_index :challenges, :featured_sequence
    add_index :locked_submissions, :challenge_id
    add_index :locked_submissions, :submission_id
    add_index :posts, :challenge_id
    add_index :posts, :participant_id
    add_index :posts, :submission_id
    add_index :publication_authors, :participant_id
    add_index :publication_authors, :publication_id
    add_index :publication_venues, :publication_id
    add_index :publication_external_links, :publication_id
    add_index :publications, :challenge_id
    add_index :submissions, :meta_challenge_id
  end
end
