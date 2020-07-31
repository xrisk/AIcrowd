class DailyBadgesJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    AicrowdBadge.where(badges_event_id: BadgesEvent.where(name: 'Daily').pluck(:id)).each do |badge|
      eval(badge.code)
    end
  end
end
