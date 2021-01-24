class CommontatorComment < ApplicationRecord
  has_many :votes, as: :votable

  def vote(participant)
    self.votes.where(participant_id: participant.id).first if participant.present?
  end

  def vote_count
    self.votes.length
  end
end
