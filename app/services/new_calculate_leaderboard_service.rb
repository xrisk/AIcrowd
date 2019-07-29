class NewCalculateLeaderboardService

  def initialize(challenge_round_id:)
    @round = ChallengeRound.find(challenge_round_id)
    @challenge = @round.challenge
    @submissions = @round.submissions.where(grading_status_cd: 'graded').where.not(participant_id: nil)
  end

  def call
    ActiveRecord::Base.transaction do
      purge_leaderboard
      make_leaderboard
    end
  end

  def purge_leaderboard
    ActiveRecord::Base.connection.execute "delete from disentanglement_leaderboards where challenge_round_id = #{@round.id};"
  end

  def make_leaderboard
    participant_set = Set.new

    @submissions.each do |subm|
      participant_set << subm.participant_id
      extra_scores = subm.other_scores_array

      DisentanglementLeaderboard.create!(
          challenge_id: subm.challenge_id,
          challenge_round_id: subm.challenge_round_id,
          participant_id: subm.participant_id,
          name: subm.name,
          score: subm.score,
          score_secondary: subm.score_secondary,
          media_large: subm.media_large,
          media_thumbnail: subm.media_thumbnail,
          media_content_type: subm.media_content_type,
          description: subm.description,
          description_markdown: subm.description_markdown,
          submission_id: subm.id,
          post_challenge: subm.post_challenge,
          meta: subm.meta,
          previous_row_num: 0,
          row_num: 0,
          entries: @round.submissions.where(participant_id: subm.participant_id).count,
          extra_score1: extra_scores[0],
          extra_score2: extra_scores[1],
          extra_score3: extra_scores[2],
          extra_score4: extra_scores[3],
          extra_score5: extra_scores[4]
      )
    end

    participant_to_best_id_map = Hash.new

    participant_set.each do |pid|
      min_avg = 10000000000
      best_id = 0

      DisentanglementLeaderboard.where(challenge_round_id: @round.id, participant_id: pid).each do |dl|
        dl.avg_rank = calculate_avg_rank(dl)
        dl.save
        if dl.avg_rank < min_avg
          min_avg = dl.avg_rank
          best_id = dl.id
        end
      end
      participant_to_best_id_map[pid] = best_id
    end

    participant_set.each do |pid|
      DisentanglementLeaderboard
          .where(challenge_round_id: @round.id, participant_id: pid)
          .where.not(id: participant_to_best_id_map[pid]).destroy_all
    end

    DisentanglementLeaderboard.where(challenge_round_id: @round.id).order(:avg_rank).each_with_index do |x, i|
      x.row_num = i + 1
      x.created_at = Submission.find(x.submission_id).created_at
      x.save
    end
  end

  def calculate_avg_rank(entry)
    @scores_to_avg = [ @challenge.score_title, @challenge.score_secondary_title ] + @challenge.other_scores_fieldnames_array
    column_names = ['score', 'score_secondary'] + (1..@challenge.other_scores_fieldnames_array.length).map { |i| 'extra_score' + (i).to_s }
    leaderboard = DisentanglementLeaderboard.where(challenge_round_id: @round.id)
    submission = Submission.find(entry.submission_id)
    sum = 0.0

    submission.meta.each do |k,v|
      if k.ends_with?('_rank')
        submission.meta.delete(k)
      end
    end

    @scores_to_avg.each_with_index do |name, i|
      col_name = column_names[i]
      submission.meta[name+"_rank"] = leaderboard.where("#{col_name} > ?", entry.send(col_name)).count + 1
      sum += submission.meta[name+"_rank"]
    end

    submission.meta['mean_rank'] = sum / @scores_to_avg.length
    submission.meta['private_ignore-leaderboard-job-computation'] = true
    submission.save
    submission.meta['mean_rank']
  end

end
