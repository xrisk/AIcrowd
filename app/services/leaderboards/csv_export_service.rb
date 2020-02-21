module Leaderboards
  class CSVExportService < ::BaseService
    def initialize(leaderboards: leaderboards)
      @leaderboards = leaderboards
      @meta_keys    = Leaderboards::SelectUniqueMetaKeysQuery.new(leaderboards).call
    end

    def call
      csv_data = CSV.generate(headers: true) do |csv_file|
        csv_file << csv_headers

        leaderboards.find_each.with_index(1) do |leaderboard, index|
          csv_file << [
            index,
            leaderboard.submitter_type,
            team_name(leaderboard),
            participants_list(leaderboard),
            leaderboard.submission_id,
            leaderboard.score,
            leaderboard.score_secondary,
            leaderboard.description,
            *meta_fields(leaderboard)
          ]
        end
      end

      success(csv_data)
    end

    private

    attr_reader :leaderboards, :meta_keys

    def csv_headers
      [
        'Rank',
        'Type',
        'Team Name',
        'Participants',
        'Submission ID',
        'Score',
        'Secondary Score',
        'Description',
        *meta_headers
      ]
    end

    def team_name(leaderboard)
      if leaderboard.submitter.present? && leaderboard.submitter_type == 'Team'
        leaderboard.submitter.name
      else
        '-'
      end
    end

    def participants_list(leaderboard)
      if leaderboard.submitter.present? && leaderboard.submitter_type == 'Team'
        leaderboard.submitter.participants.map(&:name).join(', ')
      else
        leaderboard.submitter&.name
      end
    end

    def meta_headers
      meta_keys.map(&:titleize)
    end

    def meta_fields(leaderboard)
      meta_keys.map { |key| leaderboard.meta&.fetch(key, '') }
    end
  end
end
