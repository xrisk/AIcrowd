class DiscourseMetaBadgesJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    discourse_initial_id = ENV['DISCOURSE_INITIAL_ID'].to_i

    response = Discourse::FetchBadgesMetaService.new.call

    if response.success?
      response.value.each do |badge|
        unless AicrowdBadge.exists?(name: badge['name'])
          AicrowdBadge.create!(id: discourse_initial_id.to_i + badge['id'].to_i, name: badge['name'], description: badge['description'], badges_event_id: BadgesEvent.find_by(name: 'discourse').id)
        end
      end
    end
  end
end
