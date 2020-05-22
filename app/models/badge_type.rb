class BadgeType < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  has_many :aicrowd_badges
end
