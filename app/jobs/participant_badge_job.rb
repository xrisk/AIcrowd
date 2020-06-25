class ParticipantBadgeJob < ApplicationJob
  queue_as :default

  def perform(name: , participant_id: nil, grading_status_cd: nil)
    @participant = Participant.find_by(id: participant_id)
    for badge in AicrowdBadge.where(badges_event_id: BadgesEvent.where(name: name).pluck(:id))
      eval(badge.code)
    end
  end
end
