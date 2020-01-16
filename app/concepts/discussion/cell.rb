class Discussion::Cell < Template::Cell
  def show
    render
  end

  def topic
    model
  end

  def author
    topic.participant || NullParticipant.new
  end
end
