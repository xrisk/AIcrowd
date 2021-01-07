module SubmissionsHelper
  def submission_grade_class(submission)
    if submission.grading_status_cd == 'graded'
      return 'badge-success'
    elsif submission.grading_status_cd == 'initiated'
      return 'badge-gold'
    elsif submission.grading_status_cd == 'submitted'
      return 'badge-gold'
    elsif submission.grading_status_cd == 'ready'
      return 'badge-silver'
    else
      return 'badge-warning'
    end
  end

  def submission_formatted_value(submission, value)
    format("%.#{submission.challenge_round.default_leaderboard.score_precision}f", value || 0)
  end

  def submission_enable_links_in_raw_text(text)
    return '-' if text.nil?

    value = sanitize_html(text.gsub(%r{(https?://[\S]+)}, "<a href='\\1'>\\1</a>"))

    return '-' if value.nil?

    return value
  end

  def submission_meta_hash(submission)
    meta = submission&.meta.presence
    # Return hash if already parsed
    return meta if meta.is_a? Hash
    # Try to parse if not an hash
    return JSON.parse(meta) if meta.is_a? String

    return {}
  rescue JSON::ParserError
    {}
  end

  def submission_view_description(submission)
    return false if submission.description.blank? || current_participant.blank?
    return true if current_participant&.admin? || current_participant&.id == submission.participant&.id
    return true if (current_participant&.organizer_ids & submission.challenge.organizer_ids).any?
  end

  def submission_code_link(submission)
    submission_link = nil
    if submission.present?
      meta_hash = submission_meta_hash(submission)
      if meta_hash.key?("repo_url") && meta_hash.key?("repo_ref")
        tag_name = meta_hash["repo_ref"].split('/').last
        submission_link = meta_hash["repo_url"] + '/tree/' + tag_name
      end
      if submission.submission_link.present?
        submission_link = submission.submission_link
      end
    end
    submission_link
  end

  def submission_team?(submission, participant)
    return true if submission.participant_id == participant.id
    submission_participant = Participant.find_by_id(submission.particpant_id)
    return false if submission_participant.blank?
    team = submission_participant.teams.where(challenge_id: submission.challenge_id).first
    return false if team.blank?
    participant_ids = team.team_particpants.pluck(:participant_id)
    participant_ids.include?(participant.id)
  end
end
