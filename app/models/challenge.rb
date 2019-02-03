class Challenge < ApplicationRecord
  include FriendlyId
  include Markdownable

  friendly_id :challenge,
    use: [:slugged, :finders, :history]
  before_save :reset_featured_seq
  belongs_to :organizer
  belongs_to :clef_task,
    optional: true
  has_many :dataset_files,
    dependent: :destroy
  mount_uploader :image_file, ImageUploader

  has_many :submission_file_definitions,
    dependent: :destroy,
    inverse_of: :challenge
  accepts_nested_attributes_for :submission_file_definitions,
    reject_if: :all_blank,
    allow_destroy: true
  has_many :challenge_partners, dependent: :destroy
  accepts_nested_attributes_for :challenge_partners,
    reject_if: :all_blank,
    allow_destroy: true

  has_many :challenge_rules, -> { order 'version desc' }, dependent: :destroy, class_name: "ChallengeRules"
  accepts_nested_attributes_for :challenge_rules,
    reject_if: :all_blank,
    allow_destroy: true

  has_many :challenge_participants, dependent: :destroy

  has_many :submissions, dependent: :destroy
  has_many :leaderboards,
    class_name: 'Leaderboard'
  has_many :ongoing_leaderboards,
    class_name: 'OngoingLeaderboard'
  has_many :participant_challenges,
    class_name: 'ParticipantChallenge'
  has_many :participant_challenge_counts,
    class_name: 'ParticipantChallengeCount'
  has_many :challenge_registrations,
    class_name: 'ChallengeRegistration'
  has_many :challenge_organizer_participants,
    class_name: 'ChallengeOrganizerParticipant'

  has_many :topics
  has_many :votes, as: :votable
  has_many :follows, as: :followable
  has_many :challenge_rounds,
    dependent: :destroy,
    inverse_of: :challenge
  accepts_nested_attributes_for :challenge_rounds,
    reject_if: :all_blank,
    allow_destroy: true
  has_many :challenge_round_summaries
  has_many :invitations, dependent: :destroy
  accepts_nested_attributes_for :invitations,
    reject_if: :all_blank,
    allow_destroy: true

  as_enum :status,
    [:draft, :running, :completed, :starting_soon],
    map: :string
  as_enum :primary_sort_order,
    [:ascending, :descending],
    map: :string
  as_enum :secondary_sort_order,
    [:ascending, :descending, :not_used],
    map: :string

  validates_presence_of :status
  validates_presence_of :challenge
  validates_presence_of :organizer_id
  validates_presence_of :primary_sort_order
  validates_presence_of :secondary_sort_order
  validates_uniqueness_of :challenge_client_name
  validates :challenge_client_name,
    format: { with: /\A[a-zA-Z0-9]/ }
  validates_presence_of :challenge_client_name

  default_scope {
    order("challenges.featured_sequence DESC,
            CASE challenges.status_cd
              WHEN 'running' THEN 1
              WHEN 'starting_soon' THEN 2
              WHEN 'completed' THEN 3
              WHEN 'draft' THEN 4
              ELSE 5
            END, challenges.participant_count DESC")
  }

  after_create do
    client = DiscourseApi::Client.new(ENV["DISCOURSE_DOMAIN_NAME"])
    client.api_key = ENV["DISCOURSE_API_KEY"]
    client.api_username = ENV["DISCOURSE_API_USERNAME"]
    # NATE: discourse has a hard limit of 50 chars
    # for category name length
    res = client.create_category({
      name: self.challenge.truncate(50),
      slug: self.slug[0..49],
      color: "49d9e9",
      text_color: "f0fcfd"
    })
    self.discourse_category_id = res["id"]
    self.save
  end

  after_update do
    if(self.discourse_category_id)
      client = DiscourseApi::Client.new(ENV["DISCOURSE_DOMAIN_NAME"])
      client.api_key = ENV["DISCOURSE_API_KEY"]
      client.api_username = ENV["DISCOURSE_API_USERNAME"]
      client.update_category({
        id: self.discourse_category_id,
        name: self.challenge.truncate(50),
        slug: self.slug[0..49],
        color: "49d9e9",
        text_color: "f0fcfd"
      })
    end
  end

  after_initialize do
    if self.new_record?
      self.submission_license = "Please upload your submissions and include a detailed description of the methodology, techniques and insights leveraged with this submission. After the end of the challenge, these comments will be made public, and the submitted code and models will be freely available to other crowdAI participants. All submitted content will be licensed under Creative Commons (CC)."
      self.challenge_client_name = "challenge_#{SecureRandom.hex}"
    end
  end

  def record_page_view
    self.page_views ||= 0
    self.page_views += 1
    self.save
  end

  def current_challenge_rules
    return self.challenge_rules.first
  end

  def status_formatted
    return 'Starting soon' if status == :starting_soon
    return status.capitalize
  end

  def start_dttm
    @start_dttm ||= begin
      return nil if current_round.nil? || current_round.start_dttm.nil?
      current_round.start_dttm
    end
  end

  def end_dttm
    @end_dttm ||= begin
      return nil if current_round.nil? || current_round.end_dttm.nil?
      current_round.end_dttm
    end
  end

  def submissions_remaining(participant_id)
    SubmissionsRemainingQuery
      .new(challenge: self, participant_id: participant_id).call
  end

  def current_round
    @current_round ||= self.challenge_round_summaries
      .where(round_status_cd: 'current')
      .first
  end

  def previous_round
    return nil if current_round.row_num == 1
    self.challenge_round_summaries
      .where(row_num: current_round.row_num - 1)
      .first
  end

  def round_open?
    @round_open ||= self.current_round.present?
  end

  def should_generate_new_friendly_id?
    challenge_changed?
  end

  def reset_featured_seq
    if status_changed? && (self.status == :completed || self.status == :terminated)
      self.featured_sequence = 0
    end
  end

  def post_challenge_submissions?
    self.post_challenge_submissions
  end

  def current_challenge_rules
    ChallengeRules.where(challenge_id: self.id).order("version DESC").first
  end

  def current_challenge_rules_version
    current_challenge_rules && current_challenge_rules.version
  end

  def has_accepted_challenge_rules?(participant)
    if !participant
      return
    end
    cp = ChallengeParticipant.where(challenge_id: self.id, participant_id: participant.id).first
    if !cp
      return
    end
    if (cp.challenge_rules_accepted_version != current_challenge_rules_version)
      return
    end
    if !cp.challenge_rules_accepted_date
      return
    end
    return true
  end

end
