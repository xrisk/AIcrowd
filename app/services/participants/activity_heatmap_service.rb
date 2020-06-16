module Participants
  class ActivityHeatmapService < ::BaseService
    VALUE_OF_VISIT      = 1.freeze
    VALUE_OF_SUBMISSION = 10.freeze

    def initialize(participant:)
      @participant = participant
    end

    def call
      activity      = gitlab_activity.merge(aicrowd_activity) { |key, gitlab_activity, aicrowd_activity| gitlab_activity + aicrowd_activity }
      activity_data = activity.sort_by { |key, value| key }.map { |key, value| { date: key, val: value} }

      success(activity_data)
    end

    private

    attr_reader :participant

    def aicrowd_activity
      visits      = participant.visits.group_by_day(:started_at, range: time_range).count
      submissions = participant.submissions.group_by_day(:created_at, range: time_range).count

      visits.merge(submissions) { |key, visit_count, submission_count| visit_count * VALUE_OF_VISIT + submission_count * VALUE_OF_SUBMISSION }
    end

    def gitlab_activity
      result = Rails.cache.fetch("gitlab-activity-calendar/#{participant.name}", expires_in: 15.minutes) do
        Gitlab::FetchCalendarActivityService.new(participant: participant).call
      end

      if result.success?
        result.value
      else
        {}
      end
    end

    def time_range
      time_range_end = Time.current + 1.day

      1.year.ago.midnight..time_range_end
    end
  end
end
