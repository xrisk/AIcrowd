class BadgeType < ApplicationRecord
  validates :name, uniqueness: true, presence: true
end
