class Blog < ApplicationRecord
  include FriendlyId

  friendly_id :participant,
              use: [:slugged]
  belongs_to :participant
  has_many :votes, as: :votable
  validates :posted_at, :participant, presence: true
  acts_as_commontable

  def record_page_view
    self.view_count ||= 0
    self.view_count  += 1
    save
  end

  def vote(participant)
    self.votes.where(participant_id: participant.id).first if participant.present?
  end

end
