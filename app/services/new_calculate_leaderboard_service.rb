class NewCalculateLeaderboardService

  def initialize(challenge_round_id:)
    @round = ChallengeRound.find(challenge_round_id)
    @submissions = @round.submissions.where(:grading_status == :graded)
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
      extra_scores = other_scores_array(subm)

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
          extra_score1: extra_scores[0],
          extra_score2: extra_scores[1],
          extra_score3: extra_scores[2],
          extra_score4: extra_scores[3],
          extra_score5: extra_scores[4]
      )
    end

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

      DisentanglementLeaderboard.where(
          challenge_round_id: @round.id,
          participant_id: pid
      ).where.not(id: best_id).delete_all

    end
  end

  def calculate_avg_rank(entry)
    leaderboard = DisentanglementLeaderboard.where(challenge_round_id: @round.id)
    x = 0
    x += leaderboard.where("score >= ?", entry.score).count
    x += leaderboard.where("score_secondary >= ?", entry.score_secondary).count
    x += leaderboard.where("extra_score1 >= ?", entry.extra_score1).count
    x += leaderboard.where("extra_score2 >= ?", entry.extra_score2).count
    x += leaderboard.where("extra_score3 >= ?", entry.extra_score3).count
    x += leaderboard.where("extra_score4 >= ?", entry.extra_score4).count
    x += leaderboard.where("extra_score5 >= ?", entry.extra_score5).count
    return x / 7
  end

end
