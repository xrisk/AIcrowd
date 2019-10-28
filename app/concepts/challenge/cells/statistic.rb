class Challenge::Cell::Statistic < Challenge::Cell

  def show
    render :statistic
  end

  def stat_type
    options[:type]
  end

  def challenge
    model
  end

  def stat_count
    case stat_type
    when 'submission'
      formatted_count(challenge.submissions_count)
    when 'view'
      formatted_count(challenge.page_views)
    when 'participant'
      formatted_count(challenge.challenge_participants.size)
    when 'vote'
      formatted_count(challenge.vote_count)
    end
  end

  def formatted_count(counter)
    if counter > 10000
      "#{sprintf('%.1f', counter/1000.0).chomp('.0')}k"
    else
      counter
    end
  end
end
