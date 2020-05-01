class BadgesEvent < ApplicationRecord
  validates :name, uniqueness: true, presence: true
end
