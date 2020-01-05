class Challenge < ApplicationRecord
  include FriendlyId
  include Markdownable

  friendly_id :challenge,
              use: %i[slugged finders history]

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

  has_many :challenge_rules, -> { order 'version desc' }, dependent: :destroy, class_name: 'ChallengeRules'
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

  has_many :teams, inverse_of: :challenge

  as_enum :status,
          %i[draft running completed starting_soon],
          map: :string
  as_enum :primary_sort_order,
          %i[ascending descending],
          map: :string, prefix: true
  as_enum :secondary_sort_order,
          %i[ascending descending not_used],
          map: :string, prefix: true

  validates_presence_of :status
  validates_presence_of :challenge
  validates_presence_of :organizer_id
  validates_presence_of :primary_sort_order
  validates_presence_of :secondary_sort_order
  validates_uniqueness_of :challenge_client_name
  validates :challenge_client_name,
            format: {with: /\A[a-zA-Z0-9]/}
  validates_presence_of :challenge_client_name

  validate :other_scores_fieldnames_max

  default_scope {
    order("challenges.featured_sequence,
            CASE challenges.status_cd
              WHEN 'running' THEN 1
              WHEN 'starting_soon' THEN 2
              WHEN 'completed' THEN 3
              WHEN 'draft' THEN 4
              ELSE 5
            END, challenges.participant_count DESC")
  }

  after_create :init_discourse

  after_update do
    if ENV['DISCOURSE_DOMAIN_NAME']
      if discourse_category_id
        client = DiscourseApi::Client.new(ENV['DISCOURSE_DOMAIN_NAME'])
        client.api_key = ENV['DISCOURSE_API_KEY']
        client.api_username = ENV['DISCOURSE_API_USERNAME']
        client.update_category(id: discourse_category_id,
                               name: challenge.truncate(50),
                               slug: slug[0..49],
                               color: '49d9e9',
                               text_color: 'f0fcfd'
        )
      end
    end
  end

  after_initialize do
    if new_record?
      self.submission_license = 'Please upload your submissions and include a detailed description of the methodology, techniques and insights leveraged with this submission. After the end of the challenge, these comments will be made public, and the submitted code and models will be freely available to other AIcrowd participants. All submitted content will be licensed under Creative Commons (CC).'
      self.challenge_client_name = "challenge_#{SecureRandom.hex}"
      self.featured_sequence = Challenge.count + 1
    end
  end

  def init_discourse
    if ENV['DISCOURSE_DOMAIN_NAME']
      client = DiscourseApi::Client.new(ENV['DISCOURSE_DOMAIN_NAME'])
      client.api_key = ENV['DISCOURSE_API_KEY']
      client.api_username = ENV['DISCOURSE_API_USERNAME']
      # NATE: discourse has a hard limit of 50 chars
      # for category name length
      res = client.create_category(name: challenge.truncate(50),
                                   slug: slug[0..49],
                                   color: '49d9e9',
                                   text_color: 'f0fcfd'
      )
      self.discourse_category_id = res['id']
      save
    end
  end

  def record_page_view
    self.page_views ||= 0
    self.page_views += 1
    save
  end

  def status_formatted
    'Starting soon' if status == :starting_soon
    status.capitalize
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
    SubmissionsRemainingQuery.new(challenge: self, participant_id: participant_id).call
  end

  def current_round
    @current_round ||= challenge_round_summaries.where(round_status_cd: 'current').first
  end

  def previous_round
    return nil if current_round.row_num == 1

    challenge_round_summaries.where(row_num: current_round.row_num - 1).first
  end

  def round_open?
    @round_open ||= current_round.present?
  end

  def should_generate_new_friendly_id?
    challenge_changed?
  end

  def post_challenge_submissions?
    post_challenge_submissions
  end

  def current_challenge_rules
    ChallengeRules.where(challenge_id: id).order('version DESC').first
  end

  def current_challenge_rules_version
    current_challenge_rules&.version
  end

  def has_accepted_challenge_rules?(participant)
    return false unless participant

    cp = ChallengeParticipant.where(challenge_id: id, participant_id: participant.id).first
    return false unless cp
    return false if cp.challenge_rules_accepted_version != current_challenge_rules_version
    return false unless cp.challenge_rules_accepted_date

    true
  end

  def other_scores_fieldnames_max
    errors.add(:other_scores_fieldnames, 'A max of 5 other scores Fieldnames are allowed') if other_scores_fieldnames and other_scores_fieldnames.count(',') > 4
  end

  def teams_frozen?
    return true if status == :completed

    DateTime.now > (self.team_freeze_time || end_dttm)
  end

  def other_scores_fieldnames_array
    arr = other_scores_fieldnames
    arr&.split(',')&.map(&:strip) || []
  end

end
