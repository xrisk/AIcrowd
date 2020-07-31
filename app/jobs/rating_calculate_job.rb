class RatingCalculateJob < ApplicationJob
  queue_as :default
  def start_ranking_python_service
    challenge_rounds = ChallengeRound.where('calculated_permanent=FALSE OR calculated_permanent is NULL').order(end_dttm: :asc).pluck(:id)
    RatingApiService.new.call(challenge_rounds)
  end

  def perform(*_args)
    Participant.update_all(temporary_rating: nil)
    Participant.update_all(temporary_variation: nil)
    UserRating.update_all(temporary_variation: nil)
    UserRating.update_all(temporary_rating: nil)
    start_ranking_python_service
  end
end
