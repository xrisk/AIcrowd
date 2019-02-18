class Challenge::Cell::ChallengeMasthead < Challenge::Cell

  def show
    render :challenge_masthead
  end

  def show_old
    render :challenge_masthead_old
  end

  def challenge
    model
  end

  def organizer
    model.organizer
  end

  def progress
    100 - pct_remaining
  end

  def remaining_units
    if challenge.running? && remaining_time_in_days < 1
      "Ending"
    else
      nil
    end
  end

  def remaining_text
    if challenge.running?
      if remaining_time_in_days > 0
        "#{pluralize(remaining_time_in_days,'day')} left"
      elsif remaining_time_in_hours > 0
        "#{pluralize(remaining_time_in_hours,'hour')} left (#{ending_time})"
      elsif remaining_time_in_seconds > 0
        ending_time
      end
    else
      challenge.status.to_s.humanize
    end
  end

  def organizer_view
    case challenge.id
    when 31
      render 'nips-2018-ai-for-prosthetics-challenge'
    when 28, 39, 40
      render 'nips-2018-adversarial-vision-challenge'
    else
      render 'organizer_view'
    end
  end

  def challenge_rounds
    challenge.challenge_rounds
  end

  def distance_of_time_in(unit, from, to)
    diff = to - from
    
    if 1.respond_to? unit
      distance = diff / 1.send(unit)
      distance.round
    else
      raise ArgumentError, "#{unit.inspect} is not supported as unit"
    end
  end

  def final_time(time)
    days = distance_of_time_in(:days, Time.now, time)
    if days < 0
      "Completed"
    elsif days > 30
      (days/30).to_s + " months"
    elsif days == 1
      days.to_s + " day"
    else
      days.to_s + " days"
    end
  end

end
