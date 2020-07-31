class NewsletterEmailForm
  include ActiveModel::Model

  attr_accessor :cc, :bcc, :subject, :message, :challenge, :participant, :multi_select

  validates :subject, :message, presence: true
  validates :cc, :bcc, emails_list: true

  def save
    return false if invalid?

    if cc_emails.empty? && bcc_emails.empty?
      errors.add(:base, 'Users, CC and BCC fields don\'t provide single participant e-mail')

      return false
    end

    newsletter_email = NewsletterEmail.create!(
      bcc:         bcc_emails.join(', '),
      cc:          cc_emails.join(', '),
      subject:     subject,
      message:     message,
      participant: participant,
      challenge:   challenge
    )

    Admin::NotificationsMailer.newsletter_email_notification_email(newsletter_email).deliver_later

    true
  end

  private

  def cc_emails
    @cc_emails ||= cc.split(',').map(&:strip)
  end

  def bcc_emails
    @bcc_emails ||= bcc.split(',').map(&:strip) | map_multi_select_to_emails
  end

  def map_multi_select_to_emails
    multi_select.flat_map do |select_value|
      case select_value
      when 'all_participants' # All Participants
        challenge.participants.pluck(:email)
      when 'participants_with_submission' # Participants who made at least one submission
        Participant.joins(:submissions)
                   .where(submissions: { challenge_id: challenge.id })
                   .distinct
                   .map(&:email)
      when /challenge_round/ # Participants who made at least one submission in selected round
        challenge_round_id = select_value.split('challenge_round_').second

        Participant.joins(:submissions)
                   .where(submissions: { challenge_round_id: challenge_round_id })
                   .distinct
                   .map(&:email)
      else
        select_value.split(',')
      end
    end
  end
end
