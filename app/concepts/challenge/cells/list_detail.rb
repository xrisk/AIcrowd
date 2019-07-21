class Challenge::Cell::ListDetail < Challenge::Cell

  def show
    render :list_detail
  end

  def challenge
    model
  end

end
