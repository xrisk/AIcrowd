module ChallengeParticipants
  class CSVExportService < ::BaseService
    def initialize(challenge_participants, challenge)
      @challenge_participants = challenge_participants
      @challenge = challenge
    end

    def call
      csv_data = CSV.generate(headers: true) do |csv_file|

        csv_file << csv_headers

        @challenge_participants.find_each do |challenge_participant|
          csv_file << participant_record(challenge_participant)
        end

      end
      success(csv_data)
    end

    private

    def csv_headers
      headers = [
          'Participant Name',
          'Team Name',
          'Registered',
          *participants_registration_fields
      ]
    end

    def participant_record(challenge_participant)
      participant = challenge_participant.participant
      [
          participant.name,
          get_participant_team_name(@challenge, participant),
          challenge_participant.registered,
          *participants_registration_info(challenge_participant)
      ]
    end

    def participants_registration_fields
      if @challenge.registration_form_fields.present?
        @challenge.registration_form_fields.split(',')
      else
        []
      end
    end

    def participants_registration_info(challenge_participant)
      registration_info = []
      if @challenge.registration_form_fields.present?
        @challenge.registration_form_fields.split(',').each do |field|
          if challenge_participant.registration_form_details.present? && challenge_participant.registration_form_details.key?(field)
            registration_info.push(challenge_participant.registration_form_details[field])
          else
            registration_info.push(nil)
          end
        end
      end
      return registration_info
    end

    def get_participant_team_name(challenge, participant_id)
      team = challenge.teams.joins(:team_participants).find_by(team_participants: { participant_id: participant_id})
      if team.present?
        team.name
      else
        nil
      end
    end
  end
end

