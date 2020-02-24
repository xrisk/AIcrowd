module Submissions
  class CSVExportService < ::BaseService
    def initialize(submissions: submissions)
      @submissions = submissions
      @meta_keys   = SelectUniqueMetaKeysQuery.new(submissions).call
    end

    def call
      csv_data = CSV.generate(headers: true) do |csv_file|
        csv_file << csv_headers

        submissions.find_each do |submission|
          csv_file << [
            submission.id,
            participant_name(submission),
            submission.score,
            submission.score_secondary,
            submission.description,
            *meta_fields(submission),
            submission.post_challenge,
            submission.created_at,
            submission.updated_at,
            submission.grading_message,
            submission.grading_status,
            submission.challenge_round&.challenge_round
          ]
        end
      end

      success(csv_data)
    end

    private

    attr_reader :submissions, :meta_keys

    def csv_headers
      [
        'Submission ID',
        'Participant',
        'Score',
        'Secondary Score',
        'Description',
        *meta_headers,
        'Post Challenge',
        'Created At',
        'Updated At',
        'Grading Message',
        'Grading Status',
        'Challenge Round'
      ]
    end

    def participant_name(submission)
      if submission.participant.present?
        submission.participant&.name
      else
        '-'
      end
    end

    def meta_headers
      meta_keys.map(&:titleize)
    end

    def meta_fields(submission)
      meta_keys.map { |key| submission.meta&.fetch(key, '') }
    end
  end
end
