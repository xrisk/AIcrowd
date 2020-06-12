module Discourse
  class NotificationService < ::Discourse::BaseService
    def initialize(notification:)
      @notification = notification
      @client       = prepare_http_client
      @participant  = get_participant
    end

    def call
      create_notifications
    end

    private

    attr_reader :client, :notification, :participant

    def get_participant
      with_discourse_errors_handling do
        response = get_participant_request
        username = response.body['username']

        Participant.where(name: username).first
      rescue Discourse::UnprocessableEntity => e
        raise e
      end
    end

    def get_participant_request
      client.get("/admin/users/#{notification['user_id']}.json")
    end

    def create_notifications
      return unless participant.present?

      discourse_image  = ENV['DOMAIN_NAME'] + '/assets/img/discourse.png'
      notification_url = ENV['DISCOURSE_DOMAIN_NAME'] + '/t' + "/#{notification['slug']}/#{notification['topic_id']}"
      notification_message_text = notification_message

      return if notification_message_text.nil?
      notification_record            = participant.notifications.find_or_create_by!(
                                         message: notification_message_text,
                                         notification_type: notification['notification_type'],
                                         thumbnail_url: discourse_image,
                                         notification_url: notification_url
                                       )
      notification_record.is_new     = true
      notification_record.created_at = DateTime.now.utc

      notification_record.save!
    end

    def notification_message
      i         = notification['notification_type']
      type_text = notification_types.key(i)
      case i
      when 1, 2, 9
        "#{notification['data']['original_username']} #{type_text.to_s.humanize} on Topic: #{notification['fancy_title']}"
      when 5
        # liked
        "#{notification['data']['original_username']} #{type_text.to_s.humanize} Topic: #{notification['fancy_title']}"
      end
    end

    def notification_types
      {
        mentioned: 1,
        replied:   2,
        liked:     5,
        posted:    9
      }
    end
  end
end
