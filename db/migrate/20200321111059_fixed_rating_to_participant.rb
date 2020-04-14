class FixedRatingToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :fixed_rating, :float
  end
end
