class Organizer < ApplicationRecord
  include FriendlyId
  include ApiKey

  friendly_id :organizer, use: [:slugged, :finders, :history]

  has_many :challenges_organizers, class_name: 'ChallengesOrganizer', dependent: :destroy
  has_many :challenges, through: :challenges_organizers, class_name: 'Challenge', dependent: :destroy
  has_many :participant_organizers, dependent: :destroy
  has_many :participants, dependent: :nullify, through: :participant_organizers
  has_many :clef_tasks, dependent: :destroy
  has_many :challenge_calls, dependent: :destroy
  has_many :partners, dependent: :nullify

  validates :organizer,
            presence: true
  mount_uploader :image_file, ImageUploader
  validates :tagline,
            length: { maximum:     140,
                      allow_blank: true }
  validates :tagline,
            presence: true
  before_save :set_api_key

  attr_accessor :coords_x, :coords_y, :coords_w, :coords_h

  def approved?
    approved
  end

  def clef?
    clef_organizer
  end

  def should_generate_new_friendly_id?
    organizer_changed?
  end
end
