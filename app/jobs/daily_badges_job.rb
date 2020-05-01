class DailyBadgesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    for badge in AicrowdBadge.where(badges_event_id: BadgesEvent.where(name: "Daily").pluck(:id))
      eval(badge.code)
    end
  end
end
