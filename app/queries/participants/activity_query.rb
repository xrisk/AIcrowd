module Participants
  class ActivityQuery
    VALUE_OF_VISIT      = 1.freeze
    VALUE_OF_SUBMISSION = 10.freeze

    def initialize(participant:)
      @participant = participant
    end

    def call
      visits      = participant.visits.group_by_day(:started_at, range: 1.year.ago.midnight..Time.current).count
      submissions = participant.submissions.group_by_day(:created_at, range: 1.year.ago.midnight..Time.current).count
      activity    = visits.merge(submissions) { |key, visit_count, submission_count| visit_count * VALUE_OF_VISIT + submission_count * VALUE_OF_SUBMISSION }

      activity.map { |key, value| { date: key, val: value} }
    end

    private

    attr_reader :participant
  end
end
