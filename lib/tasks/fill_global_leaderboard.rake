namespace :global_leaderboard do
  desc "destroy participant associative records if participant does not exists anymore"
  print 'destroying...'
  task fill_leaderboard: :environment do

    def both_lb(ids)
      puts "both lb calculation started"
      ids.each do |id|
        cle = ChallengeLeaderboardExtra.find(id)
        next if cle.blank?
        c = cle.challenge_round
        next if c.blank? || c.start_dttm.blank?
        date = c.start_dttm
        while(date < c.end_dttm.to_date) do
          puts "Calculation for id: #{id} and date: #{date}"
          if date + 7.days >= c.end_dttm.to_date
            cle.weight = 1
            cle.save!

            ChallengeRounds::CreateLeaderboardsService.new(challenge_round: c, challenge_leaderboard_extra: cle, is_freeze: date + 7.days, reputation_freeze_time: date + 7.days).call
            Reputation::SyncChallengeLeaderboardExtraService.new(cle.id).call
            Reputation::RatingService.new(cle.id).call

            cle.weight = 0.005
            cle.save!
          else
            ChallengeRounds::CreateLeaderboardsService.new(challenge_round: c, challenge_leaderboard_extra: cle, is_freeze: date + 7.days, reputation_freeze_time: date + 7.days).call
            Reputation::SyncChallengeLeaderboardExtraService.new(cle.id).call
            Reputation::RatingService.new(cle.id).call
          end
          puts "Calculation Ended"
          date = date + 7.days
          ratings = Rating.where('rank is null')
          ratings.each do |rating|
            global_rank = GlobalRank.where(participant_id: rating.participant_id).first_or_initialize
            global_rank.rating_id = rating.id
            global_rank.rating = rating.rating
            global_rank.save!
          end

          mv = Rating.group(:participant_id).count.values.sort
          if mv.last > 1
            puts "Same rating for multiple participants"
          end

          ActiveRecord::Base.transaction do
            sql = "select rating_id, RANK () OVER (ORDER BY rating desc) FROM global_ranks"
            rating_ranks = ActiveRecord::Base.connection.execute(sql)
            rating_ranks_hash = {}
            rating_ranks.values.each do |rating_rank|
              rating_ranks_hash[rating_rank[0]] = rating_rank[1]
            end
            GlobalRank.all.each do |gr|
              rating = gr.user_rating
              rating.rank = rating_ranks_hash[rating.id]
              rating.save!
            end
          end

          Rating.where('rank is null').delete_all
        end
      end
    end


    def final_lb(ids)
      ids.each do |id|
        cle = ChallengeLeaderboardExtra.find(id)
        c = cle.challenge_round
        date = c.start_dttm
        while(date < c.end_dttm.to_date) do
          ChallengeRounds::CreateLeaderboardsService.new(challenge_round: c, challenge_leaderboard_extra: cle, is_freeze: date + 7.days).call
          Reputation::SyncChallengeLeaderboardExtraService.new(cle.id).call
          Reputation::RatingService.new(cle.id).call
          date = date + 7.days
        end
      end
    end

    puts "verified"

    ids = [43, 44, 45, 436, 50, 51, 52, 56, 59, 60, 77, 93, 94, 95, 96, 98, 99, 104, 106, 110, 115, 116, 140, 145, 149, 154, 155, 156, 157, 158, 159, 160, 161, 162, 164, 168, 170, 171, 172, 174, 185, 188, 189, 190, 191, 192, 194, 195, 198, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 220, 279, 294, 296, 298, 300, 301, 321, 322, 324, 325, 337, 348, 361, 366, 383, 407, 408, 409, 410, 413, 435, 439, 443, 461, 468, 478, 479, 480]
    both_lb(ids)

    fr_ids = [494,495,496,497,498,499,500,501,502]
    final_lb(fr_ids)

    ids = [503,520,523]
    both_lb(ids)

    fr_ids = [527,528,529,530,531,555]
    final_lb(fr_ids)

    ids = [591]
    both_lb(ids)

    fr_ids = [612]
    final_lb(fr_ids)

    ids = [619,620,621,622]
    both_lb(ids)

    fr_ids = [629,632,636,640,642,646,652,660,669]
    final_lb(fr_ids)

    ids = [675]
    both_lb(ids)


    fr_ids = [677,678,681,682]
    final_lb(fr_ids)

    ids = [696,705,709,744]
    both_lb(ids)

    fr_ids = [761,763,771]
    final_lb(fr_ids)

    ids = [772,773,774]
    both_lb(ids)

    fr_ids = [777,779,780,781,782]
    final_lb(fr_ids)

    ids = [784,785,787,788,790,793,794,795,796,797,798,799,801,802,803,804]
    both_lb(ids)


  end
end
