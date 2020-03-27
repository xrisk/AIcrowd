class NewsletterEmailForm
  include ActiveModel::Model

  attr_accessor :group, :users, :cc, :bcc, :subject, :message, :challenge, :participant

  validates :subject, :message, presence: true
  validates :cc, :bcc, emails_list: true

  def save
    return false if invalid?

    if cc_emails.empty? && bcc_emails.empty?
      errors.add(:base, 'Groups, Users, CC and BCC fields don\'t provide single participant e-mail')

      return false
    end

    NewsletterEmail.create!(
      bcc:         bcc_emails.join(', '),
      cc:          cc_emails.join(', '),
      subject:     subject,
      message:     message,
      participant: participant
    )

    true
  end

  private

  def cc_emails
    @cc_emails ||= cc.split(',').map(&:strip)
  end

  def bcc_emails
    @bcc_emails ||= bcc.split(',').map(&:strip) | map_group_to_emails | users.reject(&:blank?)
  end

  def map_group_to_emails
    case group
    when :all_participants # All Participants
      challenge.participants.pluck(:email)
    when :participants_with_submission # Participants who made at least one submission
      Participant.joins(:submissions)
        .where(submissions: { challenge_id: challenge.id })
        .distinct
        .map(&:email)
    else # Participants who made at least one submission in selected round
      Participant.joins(:submissions)
        .where(submissions: { challenge_round_id: group })
        .distinct
        .map(&:email)
    end
  end
end
