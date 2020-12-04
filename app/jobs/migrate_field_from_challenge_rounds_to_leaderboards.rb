class MigrateFieldFromChallengeRoundsToLeaderboards < ApplicationJob
  queue_as :default

  def perform
    fields_to_migrate = ['score_title', 'score_secondary_title', 'primary_sort_order_cd', 'secondary_sort_order_cd', 'freeze_flag', 'freeze_duration', 'other_scores_fieldnames', 'other_scores_fieldnames_display', 'dynamic_score_field', 'dynamic_score_secondary_field', 'ranking_window', 'score_precision', 'score_secondary_precision', 'leaderboard_note_markdown', 'leaderboard_note']
    Challenge.all.each do |challenge|
      challenge.challenge_rounds.each do |challenge_round|
        leaderboard = ChallengeLeaderboardExtra.where(default: true, challenge_round_id: challenge_round.id).first_or_initialize
        fields_to_migrate.each do |field|
          if defined? challenge_round[field]
            leaderboard[field] = challenge_round[field]
          end
        end
        leaderboard['show_leaderboard'] = challenge['show_leaderboard']
        leaderboard['media_on_leaderboard'] = challenge['media_on_leaderboard']
        leaderboard['challenge_id'] = challenge.id
        leaderboard.save!
      end
    end
  end
end
