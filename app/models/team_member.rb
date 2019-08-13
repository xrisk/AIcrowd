class TeamMember < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :title
  validates_presence_of :section
  validates :seq, presence: true, uniqueness: true

  belongs_to :participant
end
