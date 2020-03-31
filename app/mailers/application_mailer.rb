require 'securerandom'

class ApplicationMailer < ActionMailer::Base
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def mandrill_send(options)
    message = {
      subject:           options[:subject],
      from_name:         'AIcrowd',
      from_email:        'no-reply@aicrowd.com',
      to:                emails_collection(options),
      global_merge_vars: options[:global_merge_vars],
      attachments:       options[:attachments]
    }

    if delivery_method == :letter_opener
      # TODO put this logic somewhere else so that it is not semi-duplicated in devise_mandrill_mailer
      rendered = MANDRILL.templates.render(options[:template], [], options[:global_merge_vars])
      tmp_mail = mail(
        from:    %("#{message[:from_name].gsub('"', '&quot;')}" <#{message[:from_email]}>),
        to:      options[:to],
        subject: options[:subject]
      ) do |format|
        format.html { render(html: rendered['html'].html_safe) }
      end
      tmp_mail.deliver
      return [{}, message]
    else
      res = MANDRILL.messages.send_template(options[:template], [], message)

      MandrillMessage.create!(
        res:            res,
        message:        message,
        meta:           options[:meta],
        participant_id: participant_id(options))
      return [res, message]
    end

  rescue Mandrill::UnknownTemplateError => e
    Rails.logger.debug("#{e.class}: #{e.message}")
    raise
  end

  def participant_id(options)
    participant_id = (participant.id if options[:participant].present?)
  end

  private

  def emails_collection(options)
    to_email(options) + cc_emails(options) + bcc_emails(options)
  end

  def to_email(options)
    [
      {
        email: options[:to],
        type:  'to'
      }
    ]
  end

  def cc_emails(options)
    options[:cc].to_s.split(',').map do |cc_email|
      {
        email: cc_email,
        type:  'cc'
      }
    end
  end

  def bcc_emails(options)
    options[:bcc].to_s.split(',').map do |bcc_email|
      {
        email: bcc_email,
        type:  'bcc'
      }
    end
  end
end
