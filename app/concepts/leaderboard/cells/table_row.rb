class Leaderboard::Cell::TableRow < Leaderboard::Cell

  def show
    if entry.baseline
      render :baseline_row
    else
      render :table_row
    end
  end

  def entry
    model
  end

  def challenge
    @challenge ||= model.challenge
  end

  def other_scores_array
    other_scores = []
    challenge.other_scores_fieldnames_array.each do |fname|
      if entry.meta && (entry.meta.key? fname)
        other_scores << (entry.meta[fname].nil? ? "-" : ("%.#{3}f" % entry.meta[fname].to_f))
      else
        other_scores << '-'
      end
    end
    return other_scores
  end

  def participant
    @participant ||= entry.participant
  end

  def team
    @participant ||= entry.team
  end

  def participants
    temp_participants = begin
      if entry.try(:submitter_type) == 'Team'
        entry&.team&.participants&.to_a
      else
        [entry&.participant]
      end
    end

    temp_participants = [] if temp_participants.nil? || temp_participants.include?(nil)
    return temp_participants
  end

  def top_rows
    @top_rows ||= challenge_round.ranking_highlight
  end

  def leader_class
    return 'leader' if model.row_num <= top_rows
  end

end
