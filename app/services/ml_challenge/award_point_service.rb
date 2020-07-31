module MlChallenge
  class AwardPointService < ::BaseService
    def initialize(obj_record, key)
      @obj_record = obj_record
      @key        = key

      @activity_point = ActivityPoint.find_by(activity_key: key)
    end

    def call
      case @key
      when 'submission_points', 'first_submission', 'new_challenge_signup_participation', 'participated_into_editors_selected_challenge'
        submission_points
      when 'legendary_submission', 'leaderboard_rank_change'
        leaderboards_legendary_submission
      end
    end

    private

    def submission_points
      # @obj_record is Submission object
      participant_id = @obj_record.participant_id
      challenge_id   = @obj_record.challenge_id

      if @activity_point.ml_activity_points.exists?(participant_id: participant_id, challenge_id: challenge_id) && activity_is_once_per_challenge
        return
      end

      @activity_point.ml_activity_points.create!(participant_id: participant_id, challenge_id: challenge_id)
    end

    def leaderboards_legendary_submission
      # @obj_record is Leaderboard object
      participant_id = @obj_record.participant&.id
      challenge_id   = @obj_record.challenge_id

      return unless @activity_point.present?

      if @activity_point.ml_activity_points.exists?(participant_id: participant_id, challenge_id: challenge_id) && activity_is_once_per_challenge
        return
      end

      @activity_point.ml_activity_points.create!(participant_id: participant_id, challenge_id: challenge_id)
    end

    def activity_is_once_per_challenge
      ['first_submission', 'new_challenge_signup_participation', 'legendary_submission'].include? @key
    end
  end
end
