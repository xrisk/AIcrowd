class GdprMailer < ApplicationMailer
  def export_email(participant)
    @participant           = participant
    @email_preferences_url = EmailPreferencesTokenService.new(@participant).preferences_token_url
    subject                = '[AIcrowd] Personal Data download'

    attachments['aicrowd_data.csv'] = {
      mime_type: 'file/csv',
      content:   Base64.encode64(build_csv)
    }

    mail(to: @participant.email, subject: subject)
  end

  private

  def build_csv
    CSV.generate(force_quotes: true) do |csv|
      csv << ['Participant']
      csv << participant_data
    end
  end

  def participant_data
    @participant.attributes.with_indifferent_access.slice(*Participant::GDPR_FIELDS).values
  end
end
