module ChallengeRounds
  class PopulateBordaFieldsService
    def initialize(challenge_round_id:)
      @round       = ChallengeRound.find(challenge_round_id)
      @challenge   = @round.challenge
      @submissions = @round.submissions.where(grading_status_cd: 'graded').where.not(participant_id: nil)
    end
  
    def call
      ActiveRecord::Base.transaction do
        calculate_borda_fields
      end
    end
  
    def calculate_borda_fields
      # Populate borda fields for each Submission
      # We assume submissions have their sanity on borda variables here.
      first_submission = @submissions.first
      if ! defined? first_submission['meta']['private_borda_ranking_enabled']
        raise "Borda ranking isn't enabled for this challenge"
      end
  
      overall_rank = 'private_borda_ranking_rank_sum'
      @submissions.each do |submission|
        submission['meta'][overall_rank] = 0
      end

      overall_rank = 'private_borda_ranking_rank_sum'
      1.upto(first_submission['meta']['private_borda_ranking_scores_count'].to_i) { |i|
        score_field = 'private_borda_ranking_score_' + i.to_s
        rank_field = 'private_borda_ranking_rank_' + i.to_s
        @submissions.each do |submission|
          submission['meta'][score_field] = submission['meta'][score_field].to_i
        end
        @submissions = @submissions.sort_by {|obj| obj['meta'][score_field]}.reverse
        last_value = 1e10.to_f
        rank = 0
        @submissions.each do |submission|
          if submission['meta'][score_field].to_f < last_value
            rank = rank + 1
            last_value = submission['meta'][score_field].to_f
          end
          submission['meta'][rank_field] = rank
  
          Rails.logger.error "Hello world!!!"
          Rails.logger.error submission['id']
          Rails.logger.error submission['meta'][overall_rank]
          submission['meta'][overall_rank] = submission['meta'][overall_rank] + rank
        end
      }
  
      @submissions.each do |submission|
        submission['meta']['private_ignore-leaderboard-job-computation'] = true
        submission.save!
      end
    end
  end
end
