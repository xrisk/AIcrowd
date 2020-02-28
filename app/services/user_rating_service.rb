class UserRatingService
  def initialize(round, temporary)
    @round = round
    @temporary = temporary
  end

  def call()
    leaderboard_rating_stats = LeaderboardParticipantsQuery.new.participants_with_rating @round.id, @temporary
    ranks, teams_mu, teams_sigma, teams_participant_ids = filter_leaderboard_stats leaderboard_rating_stats
    if ranks.length > 1
      new_team_ratings, new_team_variations = RatingApiService.new.call ranks, teams_mu, teams_sigma, teams_participant_ids
      if new_team_ratings.any? && new_team_variations.any?
        participant_ids, new_participant_ratings, new_participant_variations = filter_rating_api_output teams_participant_ids, new_team_ratings, new_team_variations
        update_database_columns participant_ids, new_participant_ratings, new_participant_variations
      else
        Rails.logger.info("RatingApiService could be down")
      end
    end
  end

  private
  def filter_leaderboard_stats(leaderboard_rating_stats)
    ranks, teams_mu, teams_sigma, teams_participant_ids = [], [], [], []
    for team in leaderboard_rating_stats
      if team['participant_id'].blank?
        next
      else
        teams_participant_ids << team['participant_id'].to_s.split(',')
      end
      ranks << team['seq']
      teams_mu << team['participant_mu'].to_s.split(',')
      teams_sigma << team['participant_sigma'].to_s.split(',')

    end
    return ranks, teams_mu, teams_sigma, teams_participant_ids
  end

  def filter_rating_api_output(teams_participant_ids, new_team_ratings, new_team_variations)
    participant_ids, new_participant_ratings, new_participant_variations = [], [], [], []
    teams_participant_ids.each_with_index do |team, i|
      team.each_with_index do |participant_id, j|
        participant_ids << participant_id
        if @temporary
          new_participant_ratings << {"temporary_rating" => new_team_ratings[i][j] }
          new_participant_variations << {"temporary_variation" => new_team_variations[i][j]}
        else
          new_participant_ratings << {"rating" => new_team_ratings[i][j] }
          new_participant_variations << {"variation" => new_team_variations[i][j]}
        end
      end
    end
    return participant_ids, new_participant_ratings, new_participant_variations
  end

  def update_database_columns(participant_ids, new_participant_ratings, new_participant_variations)
    ActiveRecord::Base.transaction do
      Participant.update participant_ids, new_participant_ratings
      Participant.update participant_ids, new_participant_variations
      userratings = []
      participant_ids.each_with_index do |participant_id, i|
        if @temporary
          userratings << UserRating.new(participant_id: participant_id, temporary_rating: new_participant_ratings[i]['temporary_rating'].to_f, temporary_variation: new_participant_variations[i]['temporary_variation'].to_f, challenge_round: @round)
        else
          userratings << UserRating.new(participant_id: participant_id, rating: new_participant_ratings[i]['rating'].to_f, variation: new_participant_variations[i]['variation'].to_f, challenge_round: @round)
        end
      end
      UserRating.import userratings
      if not @temporary
        @round.update_attribute :calculated_permanent, true
      end
    end
  end
end