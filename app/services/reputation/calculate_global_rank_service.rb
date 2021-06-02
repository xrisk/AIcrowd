module Reputation
  class CalculateGlobalRankService
    def initialize(ratings)
      @ratings = ratings
    end

    def call
      update_rating_ids
      update_rank
    end

    def update_rating_ids
      @ratings.each do |rating|
        global_rank = GlobalRank.where(participant_id: rating.participant_id).first_or_initialize
        global_rank.rating_id = rating.id
        global_rank.rating = rating.rating
        global_rank.save!
      end
    end

    def update_rank
      sql = "select rating_id, RANK () OVER (ORDER BY rating desc) FROM global_ranks"
      rating_ranks = ActiveRecord::Base.connection.execute(sql)
      rating_ranks_hash = {}
      rating_ranks_hash = rating_ranks.values.map {|row| rating_ranks_hash[row[0]] = row[1]}
      @ratings.each do |rating|
        rating.rank = rating_ranks_hash[rating.id]
        rating.save!
      end
    end
  end
end