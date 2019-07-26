class Challenge::Cell::ChallengeMasthead < Challenge::Cell

  def show
    render :challenge_masthead
  end

  def challenge
    model
  end

  def organizer
    model.organizer
  end

  def challenge_rounds
    challenge.challenge_rounds.where("start_dttm < ?", Time.now)
  end

end
