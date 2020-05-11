class IntercomService
  def initialize(event_name, participant, metadata = {})
    @event_name  = event_name
    @participant = participant
    @metadata    = metadata
    @client      = Intercom::Client.new(token: ENV['INTERCOM_TOKEN'])
  rescue Intercom::MisconfiguredClientError => e
    Rails.logger.info "Intercom: #{e.message}"
    raise e
  end

  def call
    return Rails.logger.info "Intercom: Participant nil" if @participant.blank?
    return Rails.logger.info "Intercom: Metadata is not a hash" unless @metadata.is_a?(Hash)

    create_event_request
  rescue Intercom::ResourceNotFound => e
    @client.contacts.create(email: @participant.email, role: "user")
    create_event_request
  rescue Intercom::IntercomError => e
    Rails.logger.info "Intercom: #{e.message}"
    raise e
  end

  private

  def create_event_request
    @client.events.create(
      event_name: @event_name,
      created_at: Time.current.to_i,
      email:      @participant.email,
      metadata:   @metadata
    )
  end
end
