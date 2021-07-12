class Mixpanel::EventJob < ApplicationJob
  queue_as :default

  def perform(participant, event, properties)
    if participant.present?
      Tracker.track(participant.uuid, event, properties)
    end
  end
end
