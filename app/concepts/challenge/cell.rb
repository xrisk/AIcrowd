class Challenge::Cell < Template::Cell

  def show
    render
  end

  def current_challenge_round
    @current_challenge_round ||= challenge.challenge_round_summaries.where(round_status_cd: 'current').first
  end

  def ending_dttm(challenge_round)
    return nil if challenge_round.nil?
    challenge_round.end_dttm.strftime("%d %b %H:%M UTC")
  end

  def ending_time(challenge_round)
    return nil if challenge_round.nil?
    challenge_round.end_dttm.strftime("%H:%M UTC")
  end

  def duration_in_seconds(challenge_round)
    return nil if challenge_round.nil?
    challenge_round.end_dttm - challenge_round.start_dttm
  end

  def remaining_time_in_seconds(challenge_round)
    return 0 if challenge_round.nil? || challenge_round.end_dttm.nil?
    seconds = challenge_round.end_dttm - Time.now
    if seconds.nil? || seconds < 0
      seconds = 0
    end
    return seconds
  end

  def remaining_time_in_hours(challenge_round)
    (remaining_time_in_seconds(challenge_round) / (60 * 60)).floor
  end

  def remaining_time_in_days(challenge_round)
    (remaining_time_in_seconds(challenge_round) / (60 * 60 * 24)).floor
  end

  def pct_remaining(challenge_round)
    if remaining_time_in_seconds(challenge_round) > 0 && duration_in_seconds > 0
      ((remaining_time_in_seconds(challenge_round) / duration_in_seconds) * 100).floor
    else
      0
    end
  end

  def remaining_text(challenge_round = current_challenge_round)
    case challenge.status
    when :running, :perpetual
      if remaining_time_in_days(challenge_round) >= 2
        "#{pluralize(remaining_time_in_days(challenge_round), 'day')} left"
      elsif remaining_time_in_hours(challenge_round) > 0
        "#{pluralize(remaining_time_in_hours(challenge_round), 'hour')} left &middot; Ending #{ending_dttm(challenge_round)}"
      elsif remaining_time_in_seconds(challenge_round) > 0
        "Less than 1 hour left &middot; Ending #{ending_dttm(challenge_round)}"
      else
        "Completed"   # display for perpetual challenges
      end
    when :draft
      "Draft"
    when :completed
      "Completed"
    when :starting_soon
      "Starting soon"
    end
  end

end
