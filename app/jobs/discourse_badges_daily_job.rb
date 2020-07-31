class DiscourseBadgesDailyJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    discourse_initial_id = ENV['DISCOURSE_INITIAL_ID'].to_i
    user_badges          = get_badges
    while user_badges.present?
      user_badges.each do |user_badge|
        participant = Participant.find_by(name: user_badge['username'])
        if participant
          badge = AicrowdBadge.find_by(id: discourse_initial_id.to_i + user_badge['badge_id'].to_i)
          participant.add_badge(badge.name)
        end
      end
      last_id     = user_badges.last['id']
      DiscourseUserBadgesMetum.create(previous_id: last_id)
      user_badges = get_badges
    end
  end

  private

  def get_badges
    previous_id = DiscourseUserBadgesMetum.order(:created_at).last&.previous_id.to_i
    Discourse::FetchBadgesService.new(previous_id).call.value
  end
end
