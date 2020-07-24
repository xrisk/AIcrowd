class AddDisentaglementFieldsToBaseLeaderboard < ActiveRecord::Migration[5.2]
  def change
    add_column :base_leaderboards, :extra_scores, :array
    add_column :base_leaderboards, :average_rank, :decimal
  end
end



# create_table "disentanglement_leaderboards", force: :cascade do |t|
#   t.float "extra_score1"
#   t.float "extra_score2"
#   t.float "extra_score3"
#   t.float "extra_score4"
#   t.float "extra_score5"
#   t.float "avg_rank"
# end


# create_table "base_leaderboards", force: :cascade do |t|
# end
