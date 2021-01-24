class AddVoteCountToCommontatorComments < ActiveRecord::Migration[5.2]
  def change
    add_column :commontator_comments, :vote_count, :integer, default: 0
  end
end
