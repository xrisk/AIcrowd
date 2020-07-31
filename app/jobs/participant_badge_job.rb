class ParticipantBadgeJob < ApplicationJob
  queue_as :default

  def perform(name:, participant_id: nil, grading_status_cd: nil, submission_id: nil)
    @submission = nil

    @submission = Submission.find(submission_id) if submission_id.present?

    if participant_id.present?
      @participant = Participant.find(participant_id)
    elsif @submission.present?
      @participant = @submission.participant
    end

    AicrowdBadge.where(badges_event_id: BadgesEvent.where(name: name).pluck(:id)).each do |badge|
      eval(badge.code)
    end
  end
end
