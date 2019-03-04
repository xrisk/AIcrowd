class Challenge::Cell::PrizesBreakdown < Challenge::Cell

  def show
    render :prizes_breakdown
  end

  def challenge
    model
  end

end
