class RatingCalculateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sorted_challenge_rounds = ChallengeRound.where("calculated_permanent=FALSE OR calculated_permanent is NULL").order(end_dttm: :asc)
    Participant.update_all(temporary_rating: nil)
    Participant.update_all(temporary_variation: nil)
    for round in sorted_challenge_rounds
      if round.end_dttm.present? && round.end_dttm < Time.current
        UserRatingService.new(round, false).call
      else
        UserRatingService.new(round, true).call
      end
    end
  end
end