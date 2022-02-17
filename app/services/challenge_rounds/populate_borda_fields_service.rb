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
      @first_submission = @submissions.first
      if ! defined? @first_submission['meta']['private_borda_ranking_enabled']
        raise "Borda ranking isn't enabled for this challenge"
      end

      @uniq_map = {}
      team_mapping = @challenge.team_participants.pluck(:participant_id, :team_id).to_h
      @submissions.pluck(:participant_id).uniq.each do |pid|
        if team_mapping[pid].nil?
          @uniq_map[pid] = pid
        else
          @uniq_map[pid] = team_mapping[pid]
        end
      end

      def run_borda_count(team_id: nil)
        overall_rank = 'private_borda_ranking_rank_sum'
        selected_submissions = @submissions
        if team_id.present?
          participant_ids = @uniq_map.select{|key, hash| hash == team_id }.keys
          overall_rank = overall_rank + '_self'
          selected_submissions = selected_submissions.where(participant_id: participant_ids)
        elsif @round.id > 800
          selected_submissions = selected_submissions.where("meta->>'private_borda_selected_for_leaderboard'='1'")
        end
        
        selected_submissions.each do |submission|
          submission['meta'][overall_rank] = 0
        end

        1.upto(@first_submission['meta']['private_borda_ranking_scores_count'].to_i) { |i|
          score_field = 'private_borda_ranking_score_' + i.to_s
          rank_field = 'private_borda_ranking_rank_' + i.to_s
          selected_submissions.each do |submission|
            submission['meta'][score_field] = submission['meta'][score_field].to_f
          end

          selected_submissions = selected_submissions.sort_by {|obj| obj['meta'][score_field]}.reverse
          last_value = 1e10.to_f
          rank = 0
          selected_submissions.each do |submission|
            if submission['meta'][score_field].to_f < last_value
              rank = rank + 1
              last_value = submission['meta'][score_field].to_f
            end
            submission['meta'][rank_field] = rank
            submission['meta'][overall_rank] = submission['meta'][overall_rank] + rank
          end
        }
        
        selected_submissions.each do |submission|
          rank_count = submission['meta']['private_borda_ranking_scores_count'].to_f
          rank_sum = submission['meta'][overall_rank].to_f
          submission['meta'][overall_rank] = (rank_sum / rank_count).round(2)
        end

        if team_id.present?
          selected_submissions.each do |submission|
            submission['meta']['private_borda_selected_for_leaderboard'] = 0
          end
          best_submission = selected_submissions.sort_by{|obj| obj['meta'][overall_rank]}.first
          best_submission['meta']['private_borda_selected_for_leaderboard'] = 1
        end

        selected_submissions.each do |submission|
          submission['meta']['private_ignore-leaderboard-job-computation'] = true
          submission.save!
        end
      end


      if @round.id > 800
        @uniq_map.values.uniq.each do |team_id|
          run_borda_count(team_id: team_id)
        end
      end

      run_borda_count()
    end
  end
end
