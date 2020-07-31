class BadgeType < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  has_many :aicrowd_badges

  def self.gold
    @@gold_badge_type ||= BadgeType.find_by(name: 'Gold')
  end

  def self.silver
    @@silver_badge_type ||= BadgeType.find_by(name: 'Silver')
  end

  def self.bronze
    @@bronze_badge_type ||= BadgeType.find_by(name: 'Bronze')
  end

  def self.other
    @@bronze_badge_type ||= BadgeType.find_by(name: 'Other')
  end
end
