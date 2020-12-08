class RemoveColumnsFromChallengeRound < ActiveRecord::Migration[5.2]
  def change
    drop_view :challenge_round_summaries
    drop_view :challenge_round_views

    remove_column :challenge_rounds, :score_title, :string
    remove_column :challenge_rounds, :score_secondary_title, :string
    remove_column :challenge_rounds, :primary_sort_order_cd, :string
    remove_column :challenge_rounds, :secondary_sort_order_cd, :string
    remove_column :challenge_rounds, :freeze_flag, :boolean
    remove_column :challenge_rounds, :freeze_duration, :integer
    remove_column :challenge_rounds, :other_scores_fieldnames, :string
    remove_column :challenge_rounds, :show_leaderboard, :boolean
    remove_column :challenge_rounds, :media_on_leaderboard, :boolean
    remove_column :challenge_rounds, :other_scores_fieldnames_display, :string
    remove_column :challenge_rounds, :score_precision, :integer
    remove_column :challenge_rounds, :score_secondary_precision, :integer
    remove_column :challenge_rounds, :leaderboard_note_markdown, :text
    remove_column :challenge_rounds, :leaderboard_note, :text
    remove_column :challenge_rounds, :ranking_window, :integer
  end
end
