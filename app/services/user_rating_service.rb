class UserRatingService
  attr_accessor :temporary, :round
  def initialize(round_id)
    @round     = ChallengeRound.find_by(id: round_id)
    @temporary = if @round&.end_dttm.present? && @round.end_dttm < Time.current
                   false
                 else
                   true
                 end
    @weight    = @round.challenge.weight
  end

  def leaderboard_query
    LeaderboardParticipantsQuery.new.call @round.id, @temporary
  end

  def filter_leaderboard_stats(leaderboard_rating_stats)
    ranks                 = []
    teams_rating          = []
    teams_variation       = []
    teams_participant_ids = []
    leaderboard_rating_stats.each do |team|
      if team['participant_id'].blank?
        next
      else
        teams_participant_ids << team['participant_id'].to_s.split(',')
      end

      ranks << team['seq']
      teams_rating << team['participant_rating'].to_s.split(',')
      teams_variation << team['participant_variation'].to_s.split(',')
    end
    [ranks, teams_rating, teams_variation, teams_participant_ids]
  end

  def filter_rating_api_output(teams_participant_ids, new_team_ratings, new_team_variations)
    participant_ids            = []
    new_participant_ratings    = []
    new_participant_variations = []
    teams_participant_ids.each_with_index do |team, i|
      team.each_with_index do |participant_id, j|
        participant_ids << participant_id
        if @temporary
          new_participant_ratings << { 'temporary_rating' => new_team_ratings[i][j] }
          new_participant_variations << { 'temporary_variation' => new_team_variations[i][j] }
        else
          current_participant                    = Participant.find_by(id: participant_id)
          current_participant_previous_rating    = current_participant.rating.to_f
          current_participant_true_rating        = new_team_ratings[i][j].to_f
          current_participant_previous_variation = current_participant.variation.to_f
          current_participant_true_variation     = new_team_variations[i][j].to_f
          current_participant_weighted_rating    = current_participant_previous_rating + @weight * (current_participant_true_rating - current_participant_previous_rating)
          current_participant_weighted_variation = current_participant_previous_variation + (@weight**2) * (current_participant_true_variation - current_participant_previous_variation)
          new_participant_ratings << { 'rating' => current_participant_weighted_rating, 'fixed_rating' => current_participant_weighted_rating }
          new_participant_variations << { 'variation' => current_participant_weighted_variation }
        end
      end
    end
    [participant_ids, new_participant_ratings, new_participant_variations]
  end

  def update_challenge_permanent
    @round.update!(calculated_permanent: true) unless @temporary
  end

  def update_database_columns(participant_ids, new_participant_ratings, new_participant_variations)
    ActiveRecord::Base.transaction do
      Participant.update participant_ids, new_participant_ratings
      Participant.update participant_ids, new_participant_variations
      user_ratings = []
      participant_ids.each_with_index do |participant_id, i|
        if @temporary
          user_ratings << UserRating.new(participant_id: participant_id, temporary_rating: new_participant_ratings[i]['temporary_rating'].to_f, temporary_variation: new_participant_variations[i]['temporary_variation'].to_f, challenge_round: @round, created_at: @round.end_dttm)
        else
          user_ratings << UserRating.new(participant_id: participant_id, rating: new_participant_ratings[i]['rating'].to_f, variation: new_participant_variations[i]['variation'].to_f, challenge_round: @round, created_at: @round.end_dttm)
        end
      end
      UserRating.import user_ratings
      @round.update!(calculated_permanent: true) unless @temporary
    end
  end
end
