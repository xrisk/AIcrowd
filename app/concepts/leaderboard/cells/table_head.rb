class Leaderboard::Cell::TableHead < Leaderboard::Cell

  def show
    render :table_head
  end

  def other_scores_fieldnames_array
	challenge.other_scores_fieldnames.split(",")
  end

end
