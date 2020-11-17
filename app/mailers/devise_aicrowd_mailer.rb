class DeviseAicrowdMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  default from: 'no-reply@aicrowd.com'
  layout 'mailer'

  def reset_password_instructions(record, token, opts = {})
    @record = record
    @token  = token
    subject = '[AIcrowd] Password Reset'

    mail(to: @record.email, subject: subject)
  end

  def confirmation_instructions(record, token, opts = {})
    @record = record
    @token  = token
    subject = '[AIcrowd] Confirmation Instructions'
    to = (record.confirmed? && record.unconfirmed_email.present?) ? record.unconfirmed_email : record.email

    mail(to: to, subject: subject)
  end

  def unlock_instructions(record, token, opts = {})
    @record = record
    @token  = token
    subject = '[AIcrowd] Unlock Instructions'

    mail(to: @record.email, subject: subject)
  end
end
