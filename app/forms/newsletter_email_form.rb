class NewsletterEmailForm
  include ActiveModel::Model

  attr_accessor :group, :cc, :bcc, :subject, :message, :challenge

  validates :group, :subject, :message, presence: true

  # def initialize(params= {})
  #   @newsletter_email = NewsletterEmail.new
  #   super(params)
  # end

  def save
    return false if invalid?

    return false if cc_emails.empty? && bcc_emails.empty?

    NewsletterEmail.create!(
      emails_list: bcc_emails,
      cc:          cc_emails,
      subject:     subject,
      message:     message
    )

    true
  end

  private

  def cc_emails
    @cc_emails ||= cc.split(',').map(&:strip)
  end

  def bcc_emails
    @bcc_emails ||= bcc.split(',').map(&:strip) | map_group_to_emails
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

# All participants: All the users who have participated in this challenge/showed interest. (challenge_participant table)
# Participants will submissions: All users who have made at least one submission
# Participants of “Round 1”: All users who have at least one submission in Round 1
# Participants of “Round X”: All users who have at least one submission in Round X
# (populate based on the names of rounds in the challenge)
# Participant.joins(:submissions).where(submissions: { challenge_id: challenge.id }).distinct.map(&:email)
# Participant.joins(:submissions).where(submissions: { challenge_round_id: group }).distinct.map(&:email)
