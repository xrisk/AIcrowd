class Submission::Cell::TableRow < Submission::Cell

  def show
    render :table_row
  end

  def participant_link
    if participant
      link_to participant.name, participant_path(participant)
    else
      "Unknown Participant"
    end
  end
end
