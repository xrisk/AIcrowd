module FreezeRecord
  extend ActiveSupport::Concern

  included do
    def self.freeze_record(participant)
      return all if first.nil? || participant_is_organizer(participant&.email) || participant&.admin?

      ch_round = first.challenge_round
      if freeze_duration?(participant)
        freeze_beyond_time = ch_round.end_dttm - ch_round.freeze_duration.to_i.hours

        participant_and_before_freeze_record  = where('participant_id = ? OR created_at < ?', participant&.id, freeze_beyond_time)

        return participant_and_before_freeze_record
      end

      all
    end

    def self.participant_is_organizer(participant_email)
      organizers_email = first.challenge.organizers.flat_map { |organizer| organizer.participants }.pluck(:email)
      organizers_email.include?(participant_email)
    end

    def self.freeze_duration?(_participant)
      return if count.zero?

      ch_round = first.challenge_round
      first.is_freeze?(ch_round)
    end

    def is_freeze?(challenge_round)
      challenge_round.freeze_flag && freeze_time(challenge_round)
    end

    def freeze_time(ch_round)
      return false if ch_round.end_dttm.nil? || (ch_round.end_dttm - Time.now.utc).negative?

      ch_round.end_dttm - Time.now.utc < ch_round.freeze_duration * 60 * 60
    end
  end
end
