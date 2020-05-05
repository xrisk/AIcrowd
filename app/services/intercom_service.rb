class IntercomService
  def initialize
    @client = Intercom::Client.new(token: ENV['INTERCOM_TOKEN'])
  end

  def send_event(event_name, participant, metadata = {})
    @client.events.create(
        event_name: event_name,
        created_at: Time.now.to_i,
        email: participant.email,
        metadata: metadata
    )

  end
end
