class Submission::Cell::TableRow < Submission::Cell

  def show
    render :table_row
  end

  def entry
    model
  end

  def grade_class
    if entry.grading_status_cd == "graded"
      return "badge-success"
    else
      return "badge-warning"
    end
  end

  def challenge
    @challenge ||= model.challenge
  end

  def participant
    @participant ||= entry.participant
  end

  def formatted_value(value)
    if value == nil
      return "-"
    else
      return value
    end
  end
end
