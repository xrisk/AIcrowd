class Leaderboard::Cell::TableHead < Leaderboard::Cell

  def show
    render :table_head
  end

  def other_scores_fieldnames_array
    arr = challenge.other_scores_fieldnames
    return arr.split(",") if arr
  end

end
