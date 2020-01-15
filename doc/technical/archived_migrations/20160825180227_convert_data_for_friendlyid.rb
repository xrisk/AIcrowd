class ConvertDataForFriendlyid < ActiveRecord::Migration
  def change
    Challenge.find_each(&:save)
    Comment.find_each(&:save)
    Organizer.find_each(&:save)
    Participant.find_each(&:save)
    Post.find_each(&:save)
    Topic.find_each(&:save)
  end
end
