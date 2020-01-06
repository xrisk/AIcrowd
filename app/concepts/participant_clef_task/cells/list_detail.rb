class ParticipantClefTask::Cell::ListDetail < ParticipantClefTask::Cell

  def show
    render :list_detail
  end

  def participant_clef_task
    model
  end

  def clef_task
    @clef_task ||= participant_clef_task.clef_task
  end

  def eua_file
    @eua_file ||= participant_clef_task.eua_file
  end

  def challenge_id
    @challenge_id ||= options[:challenge_id]
  end

  def participant
    @participant ||= participant_clef_task.participant
  end

  def clef_status
    case participant_clef_task.status_cd
    when 'requested'
      return "<button class='btn btn-small btn-default'>EUA downloaded</button>"
    when 'submitted'
      return "<button class='btn btn-small btn-default'>Submitted [Cant approve for unknown user]</button>" if participant.nil?
      return "<button class='btn btn-small btn-default'>Missing</button>" if eua_file.blank?
      return "#{ link_to 'Approve', participant_clef_task_path(clef_task, participant_id: participant.id, challenge_id: challenge_id), method: :patch, remote: true, class: 'btn btn-small btn-primary' }"
    when 'registered'
      return "<button class='btn btn-small btn-default'>Approved</button>"
    end
  end

end
