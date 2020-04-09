class DiscourseBadgesDailyJob < ApplicationJob
  queue_as :default
  def perform(*args)
    discourse_initial_id = ENV['DISCOURSE_INITIAL_ID'].to_i
    previous_id = DiscourseUserBadgesMetum.order(:created_at).last&.previous_id.to_i
    user_badges = Discourse::FetchBadgesService.new(previous_id).call.value
    user_badges.each do |user_badge|
      puts user_badge['badge'].to_i
      Participant.find_by(name: user_badge['username'])&.add_badge(discourse_initial_id + user_badge['badge_id'].to_i)
    end
    last_id = user_badges.last['id']
    DiscourseUserBadgesMetum.create(previous_id: last_id)
  end
end
