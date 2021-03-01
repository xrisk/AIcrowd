module Submissions
  class CSVExportService < ::BaseService
    def initialize(submissions: submissions, downloadable:downloadable)
      @submissions = submissions
      @downloadable = downloadable
      @meta_keys   = SelectUniqueMetaKeysQuery.new(submissions).call
    end

    def call
      csv_data = CSV.generate(headers: true) do |csv_file|
        csv_file << csv_headers

        submissions.find_each do |submission|
          data_instance = [
            submission.id,
            submission_type(submission),
            team_name(submission),
            participants_list(submission),
            submission.score,
            submission.score_secondary,
            submission.description,
            *meta_fields(submission),
            submission.post_challenge,
            submission.created_at,
            submission.updated_at,
            submission.grading_message,
            submission.grading_status,
            submission.challenge_round&.challenge_round,
            submission.challenge_round_id
          ]
          if downloadable
            links = []
            if submission.submission_files.present?
              submission.submission_files.each do |file|
                links += [S3Service.new(file.submission_file_s3_key).expiring_url]
              end
            end
            data_instance += [links * ' ; ']
          end
          csv_file << data_instance
        end
      end

      success(csv_data)
    end

    private

    attr_reader :submissions, :meta_keys, :downloadable

    def csv_headers
      headers = [
        'Submission ID',
        'Type',
        'Team Name',
        'Participants',
        challenge_round&.default_leaderboard&.score_title,
        challenge_round&.default_leaderboard&.score_secondary_title,
        'Description',
        *meta_headers,
        'Post Challenge',
        'Created At',
        'Updated At',
        'Grading Message',
        'Grading Status',
        'Challenge Round',
        'Challenge Round ID',
      ]
      if downloadable
        headers += ['Download Links']
      end
      return headers
    end

    def challenge_round
      @challenge_round ||= submissions.first&.challenge_round
    end

    def submission_type(submission)
      if submission.team.present?
        'Team'
      else
        'Participant'
      end
    end

    def team_name(submission)
      if submission.team.present?
        submission.team.name
      else
        '-'
      end
    end

    def participants_list(submission)
      if submission.team.present?
        submission.team.participants.map(&:name).join(', ')
      else
        submission.participant&.name
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
