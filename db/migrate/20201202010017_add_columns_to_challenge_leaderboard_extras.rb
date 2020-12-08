class AddColumnsToChallengeLeaderboardExtras < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_leaderboard_extras, :challenge_round_id, :int, null: false, default: -1
    add_column :challenge_leaderboard_extras, :score_title, :string, default: 'Score'
    add_column :challenge_leaderboard_extras, :score_secondary_title, :string, default: 'Secondary Score'
    add_column :challenge_leaderboard_extras, :primary_sort_order_cd, :string, default: 'ascending'
    add_column :challenge_leaderboard_extras, :secondary_sort_order_cd, :string, default: 'not_used'
    add_column :challenge_leaderboard_extras, :freeze_flag, :boolean, default: false
    add_column :challenge_leaderboard_extras, :freeze_duration, :integer
    add_column :challenge_leaderboard_extras, :other_scores_fieldnames, :string
    add_column :challenge_leaderboard_extras, :show_leaderboard, :boolean, default: true
    add_column :challenge_leaderboard_extras, :media_on_leaderboard, :boolean, default: false
    add_column :challenge_leaderboard_extras, :other_scores_fieldnames_display, :string
    add_column :challenge_leaderboard_extras, :dynamic_score_field, :string
    add_column :challenge_leaderboard_extras, :dynamic_score_secondary_field, :string
    add_column :challenge_leaderboard_extras, :ranking_window, :integer, default: 96
    add_column :challenge_leaderboard_extras, :score_precision, :integer, default: 3
    add_column :challenge_leaderboard_extras, :score_secondary_precision, :integer, default: 3
    add_column :challenge_leaderboard_extras, :leaderboard_note_markdown, :text
    add_column :challenge_leaderboard_extras, :leaderboard_note, :text
    add_column :challenge_leaderboard_extras, :default, :boolean, default: true
  end
end
