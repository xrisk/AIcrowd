module Leaderboards
  class CSVExportService < ::BaseService
    def initialize(leaderboards: leaderboards)
      @leaderboards = leaderboards
      @meta_keys    = SelectUniqueMetaKeysQuery.new(leaderboards).call
    end

    def call
      csv_data = CSV.generate(headers: true) do |csv_file|
        csv_file << csv_headers(@leaderboards.first)

        leaderboards.find_each.with_index(1) do |leaderboard, index|
          csv_file << [
            index,
            leaderboard.submitter_type,
            team_name(leaderboard),
            participants_list(leaderboard),
            *participants_registration_info(leaderboard),
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

    def csv_headers(leaderboard)
      [
        'Rank',
        'Type',
        'Team Name',
        'Participants',
        *participants_registration_fields(leaderboard),
        'Submission ID',
        challenge_round&.score_title,
        challenge_round&.score_secondary_title,
        'Description',
        *meta_headers
      ]
    end

    def challenge_round
      @challenge_round ||= leaderboards.first&.challenge_round
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

    def participants_registration_fields(leaderboard)
      if leaderboard.challenge.registration_form_fields.present?
        leaderboard.challenge.registration_form_fields.split(',')
      else
        []
      end
    end

    def participants_registration_info(leaderboard)
      registration_info = []
      if leaderboard.challenge.registration_form_fields.present?
        challenge_participants = []
        if leaderboard.submitter.present? && leaderboard.submitter_type == 'Team'
          leaderboard.submitter.participants.each do |participant|
            challenge_participants.push(ChallengeParticipant.find_by(challenge_id: leaderboard.challenge.id, participant_id: participant.id))
          end
        else
          challenge_participants.push(ChallengeParticipant.find_by(challenge_id: leaderboard.challenge.id, participant_id: leaderboard.submitter.id))
        end

        leaderboard.challenge.registration_form_fields.split(',').each do |field|
          this_field_data = []
          challenge_participants.each do |cp|
            if cp.registration_form_details.present? && cp.registration_form_details.key?(field)
              this_field_data.push(cp.registration_form_details[field])
            else
              this_field_data.push('-')
            end
          end
          registration_info.push(this_field_data.join(','))
        end
      end

      return registration_info
    end

    def meta_headers
      meta_keys.map(&:titleize)
    end

    def meta_fields(leaderboard)
      meta_keys.map { |key| leaderboard.meta&.fetch(key, '') }
    end
  end
end
