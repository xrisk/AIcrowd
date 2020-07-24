class FeedbackMailer < ApplicationMailer
  add_template_helper(SanitizationHelper)

  DEFAULT_FEEDBACK_EMAIL_ADDRESS = 'feedback@aicrowd.com'.freeze

  def feedback_email(feedback)
    @feedback = feedback
    subject   = "[#{feedback.participant.name}] Feedback about AICrowd"

    mail(to: DEFAULT_FEEDBACK_EMAIL_ADDRESS, subject: subject)
  end
end
