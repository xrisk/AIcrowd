class IntercomService
  def initialize
    begin
      @client = Intercom::Client.new(token: ENV['INTERCOM_TOKEN'])
    rescue Intercom::MisconfiguredClientError => e
      Rails.logger.info "Intercom: #{e.message}"
      raise
    end

    def call(event_name, participant, metadata = {})
      if participant&.email.present? and metadata.is_a?(Hash)
        begin
          @client.events.create(
              event_name: event_name,
              created_at: Time.now.to_i,
              email: participant.email,
              metadata: metadata
          )
        rescue Intercom::ResourceNotFound => e
          @client.contacts.create(email: participant.email, role: "user")
          @client.events.create(
              event_name: event_name,
              created_at: Time.now.to_i,
              email: participant.email,
              metadata: metadata
          )
        rescue Intercom::IntercomError => e
          Rails.logger.info "Intercom: #{e.message}"
          raise
        end
      elsif !participant&.email.present?
        Rails.logger.info "Intercom: Email for the participant or missing"
      elsif !participant.present?
        Rails.logger.info "Intercom: Participant nil"
      elsif !metadata.is_a?(Hash)
        Rails.logger.info "Intercom: Metadata is not a string"
      end
    end
  end
end
