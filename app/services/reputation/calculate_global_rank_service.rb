module Reputation
  class CalculateGlobalRankService
    def initialize(ratings)
      @ratings = ratings
    end

    def call
      update_rating_ids
      update_rank
      update_rating
    end

    def update_ratings_ids
      @ratings.each do |rating|
        global_rank = GlobalRank.where(participant_id: rating.participant_id).first_or_initialize
        global_rank.rating_id = rating.id
        global_rank.rating = rating.rating
      end
    end

    def update_rank
      GlobalRank.order(:rating).each_with_index do |gr, index|
        gr.rank = index + 1
        gr.save!
      end
    end

    def update_rating
      @ratings.each do |rating|
        rank = GlobalRank.where(rating_id: rating.id).first.rank
        rating.rank = rank
        rating.save!
      end
    end
  end
end