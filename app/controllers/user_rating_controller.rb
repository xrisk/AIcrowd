class UserRatingController < ApplicationController
  def get_leaderboard_ranks
    user_rating_service = UserRatingService.new(params[:round_id])
    challenge_round = ChallengeRound.find_by(id:params[:round_id])
    leaderboard_rating_stats = user_rating_service.leaderboard_query
    ranks, teams_rating, teams_variation, teams_participant_ids = user_rating_service.filter_leaderboard_stats leaderboard_rating_stats
    teams_participant_ids.map do |participant_id|
      participant = Participant.find_by(id: participant_id[0])
      user_final_rating =  UserRating.where("participant_id=#{participant_id[0]} and rating is not null and challenge_round_id is not null").joins(:challenge_round).reorder('user_ratings.created_at desc').select("user_ratings.*, challenge_rounds.end_dttm").first
      if user_final_rating.present?
        time_difference = (challenge_round.end_dttm.to_date - user_final_rating[:end_dttm].to_date)
        time_difference = time_difference.to_i
        total_number_of_days = 365
        updated_rating = participant.fixed_rating * (Math.exp(-time_difference/total_number_of_days))
        participant.update!({rating: updated_rating})
        UserRating.create!(participant_id: participant.id, rating: updated_rating, variation: user_final_rating['variation'], challenge_round: nil, created_at: challenge_round.end_dttm)
        ranks, teams_rating, teams_variation, teams_participant_ids = user_rating_service.filter_leaderboard_stats leaderboard_rating_stats
        end
      end
    response = {
        ranks: ranks,
        teams_rating: teams_rating,
        teams_variation: teams_variation,
        teams_participant_ids: teams_participant_ids
    }
    render json: response.to_json
  end
  def post_new_participant_ratings
    if params[:calculate_leaderboard]
      ParticipantRatingRanksQuery.new.call
      response = {
          success: true
      }
      render json: response.to_json
    end
    user_rating_service = UserRatingService.new(params[:round_id])
    teams_participant_ids, new_team_ratings, new_team_variations = params[:participant_ids], params[:final_rating], params[:final_variation]
    if new_team_ratings.present? && new_team_variations.present?
      participant_ids, new_participant_ratings, new_participant_variations = user_rating_service.filter_rating_api_output teams_participant_ids, new_team_ratings, new_team_variations
      user_rating_service.update_database_columns participant_ids, new_participant_ratings, new_participant_variations
    end
  end
end
