module MlChallenge
  class AwardScoreImprovedPointService < ::BaseService
    def initialize(obj_record, key)
      @obj_record         = obj_record # Submission object
      @key                = key # score_improved_over_5_times
      @participant        = @obj_record.participant
      @challenge_id       = @obj_record.challenge_id
      @challenge_round_id = @obj_record.challenge_round_id
      @activity_point     = ActivityPoint.find_by(activity_key: key)
    end

    def call
      @get_score = get_score

      @activity_point.ml_activity_points.create!(participant_id: @participant.id, challenge_id: @challenge_id, point: @get_score) if @get_score > 0
    end

    private

    def get_score
      participant_submissions = @participant.submissions.where('challenge_id = ? AND challenge_round_id = ? AND created_at > ?', @challenge_id, @challenge_round_id, Time.now.beginning_of_day).order(:created_at)

      return 0 if participant_submissions.count < 2

      times      = 0
      best_score = nil

      participant_submissions.each do |submission|
        next if submission.score.nil?

        best_score = submission.score if best_score.nil?

        if submission.score > best_score
          times     += 1
          best_score = submission.score
        end
      end
      [times, 10].min * 5
    end
  end
end
