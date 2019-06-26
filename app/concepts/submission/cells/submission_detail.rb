class Submission::Cell::SubmissionDetail < Submission::Cell

  def show
    render :submission_detail
  end

  def entry
  	model
  end

  def current_participant
  	options[:current_participant]
  end

  def view_description
    if entry.description.blank?
        return false
    end
    if current_participant.admin? || current_participant.id == participant.id
        return true
    end
    if current_participant.organizer && current_participant.organizer.id == challenge.organizer.id
        return true
    end
  end

end
