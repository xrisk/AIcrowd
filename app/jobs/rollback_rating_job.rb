
class RollbackRatingJob < ApplicationJob
  queue_as :default

  def perform(end_dttm_was_string)
    end_dttm_was = Time.parse(end_dttm_was_string)

    ActiveRecord::Base.transaction do
      ChallengeRound.where(["end_dttm >=?","#{end_dttm_was}"]).update_all(calculated_permanent: false)
      to_be_deleted_ratings = UserRating.where(['created_at >=?', "#{end_dttm_was}"])
      participant_ids = to_be_deleted_ratings.distinct('participant_id').pluck(:participant_id)
      to_be_deleted_ratings.destroy_all
      participant_ids.map do |participant_id|
        user_rating =  UserRating.where(['participant_id=? and rating is not null', "#{participant_id}"]).reorder('created_at desc').first
        updated_rating = {
            'rating': user_rating&.rating.to_f,
            'variation': user_rating&.variation.to_f
        }
        Participant.find_by(id: participant_id).update!(updated_rating)
      end
    end
    if ENV["RATING_API_URL"].present?
      RatingCalculateJob.perform_later
    end
  end
end
