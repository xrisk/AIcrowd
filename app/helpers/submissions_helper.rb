module SubmissionsHelper
  def submission_grade_class(submission)
    if submission.grading_status_cd == 'graded'
      'badge-success'
    elsif submission.grading_status_cd == 'initiated'
      'badge-gold'
    elsif submission.grading_status_cd == 'submitted'
      'badge-gold'
    elsif submission.grading_status_cd == 'ready'
      'badge-silver'
    else
      'badge-warning'
    end
  end

  def submission_formatted_value(submission, value)
    format("%.#{submission.challenge_round.score_precision}f", value || 0)
  end

  def submission_enable_links_in_raw_text(text)
    return '-' if text.nil?

    value = sanitize_html(text.gsub(%r{(https?://[\S]+)}, "<a href='\\1'>\\1</a>"))

    return '-' if value.nil?

    value
  end

  def submission_meta_hash(submission)
    meta = submission&.meta.presence
    # Return hash if already parsed
    return meta if meta.is_a? Hash
    # Try to parse if not an hash
    return JSON.parse(meta) if meta.is_a? String

    {}
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
      meta_hash       = submission_meta_hash(submission)
      if meta_hash.key?('repo_url') && meta_hash.key?('repo_ref')
        tag_name        = meta_hash['repo_ref'].split('/').last
        submission_link = meta_hash['repo_url'] + '/tree/' + tag_name
      end
      submission_link = submission.submission_link if submission.submission_link.present?
    end
    submission_link
  end
end
