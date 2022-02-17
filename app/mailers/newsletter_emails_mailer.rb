class NewsletterEmailsMailer < ApplicationMailer
  add_template_helper(SanitizationHelper)

  default from: 'connect@aicrowd.com'

  def organizer_email(newsletter_email)
    @newsletter_email = newsletter_email
    @challenge        = newsletter_email.challenge

    subject = "[#{@challenge&.challenge}] #{@newsletter_email.subject}"

    mail(to: @newsletter_email.participant.email, cc: allowed_emails(@newsletter_email, :cc), bcc: allowed_emails(@newsletter_email, :bcc), subject: subject, reply_to: newsletter_email.participant.email)
  end

  def declined_email(newsletter_email)
    @newsletter_email = newsletter_email
    @challenge        = newsletter_email.challenge

    subject = "[#{@challenge&.challenge}] Your newsletter e-mail was declined"

    mail(to: @newsletter_email.participant.email, subject: subject)
  end

  private

  def allowed_emails(newsletter_email, attribute)
    newsletter_emails   = newsletter_email.public_send(attribute).split(',').map(&:strip)
    existing_emails     = Participant.where(email: newsletter_emails).pluck(:email)
    not_existing_emails = newsletter_emails - existing_emails
    allowed_emails      = Participant.where(email: existing_emails, agreed_to_organizers_newsletter: true).pluck(:email)

    (not_existing_emails + allowed_emails).join(',')
  end
end
