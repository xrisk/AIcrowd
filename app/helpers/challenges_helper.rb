module ChallengesHelper
  def participant_invitation(email:)
    participant = Participant.find_by(email: email)
    if participant.present?
      link_to participant.name, participant_path(participant)
    else
      'No AIcrowd account'
    end
  end

  def status_dropdown_helper(builder:)
    challenge = builder.object
    statuses  = Challenge.statuses.hash
    statuses  = statuses.except(:running, :completed, :terminated) if challenge.challenge_rounds.none? || challenge.dataset_files.none?
    builder.select(:status, statuses.map { |k, v| [v.humanize, k] }, {}, { class: 'form-control', required: true })
  end

  def required_terms_or_rules_path(challenge)
    if params.has_key?('meta_challenge_id') || params.has_key?('ml_challenge_id')
      challenge_id = params[:meta_challenge_id].present? ? params[:meta_challenge_id] : params[:ml_challenge_id]
      challenge    = Challenge.friendly.find(challenge_id)
    end

    if !policy(challenge).has_accepted_participation_terms?
      [challenge, ParticipationTerms.current_terms]
    elsif !policy(challenge).has_accepted_challenge_rules?
      challenge_challenge_rules_path(challenge)
    end
  end

  def challenge_remaining_text(challenge, challenge_round)
    case challenge.status
    when :running, :perpetual
      if remaining_time_in_days(challenge_round) >= 2
        "#{pluralize(remaining_time_in_days(challenge_round), 'day')} left"
      elsif remaining_time_in_hours(challenge_round) > 0
        sanitize_html("#{pluralize(remaining_time_in_hours(challenge_round), 'hour')} left &middot; Ending #{ending_dttm(challenge_round)}")
      elsif remaining_time_in_seconds(challenge_round) > 0
        sanitize_html("Less than 1 hour left &middot; Ending #{ending_dttm(challenge_round)}")
      else
        'Completed' # display for perpetual challenges
      end
    when :draft
      'Draft'
    when :completed
      'Completed'
    when :starting_soon
      'Starting soon'
    end
  end

  def is_draft_practice(challenge)
    'Draft' if challenge.status == :draft || challenge.status == :starting_soon
  end

  def challenge_stat_count(challenge, stat_type, parent_meta_challenge = nil)
    case stat_type
    when 'submission'
      challenge_submissions_count(challenge, parent_meta_challenge)
    when 'view'
      challenge_page_views_count(challenge)
    when 'participant'
      challenge_participants_count(challenge, parent_meta_challenge)
    when 'team'
      challenge_teams_count(challenge, parent_meta_challenge)
    end
  end

  def filter_message(status, categories, prizes)
    text  = 'Filter challenges '
    text += "[from #{categories} category] " if categories.present?
    text += "[with status #{status}] " if status.present?
    text += "[prizes in form of #{prizes}]" if prizes.present?
    text
  end

  def check_selected_category(category)
    return false unless params[:categories].present?

    params[:categories].split(',').include?(category.name)
  end

  def check_selected_prize(prize)
    return false unless params[:prizes].present?

    params[:prizes].split(',').include?(prize.to_s)
  end

  def categories_select_options(challenge)
    challenge_category = challenge.categories.pluck(:name)
    raw_options        = ''
    Category.pluck(:name).each do |category_name|
      if challenge_category.include?(category_name)
        raw_options << sanitize_html_with_attr("<option selected='selected' value='#{category_name}''>#{category_name.parameterize.underscore}</option>", elements: ['option'], attributes: { 'option' => ['selected', 'value'] })
      else
        raw_options << sanitize_html_with_attr("<option value='#{category_name}''>#{category_name.parameterize.underscore}</option>", elements: ['option'], attributes: { 'option' => ['value'] })
      end
    end
    raw(raw_options)
  end

  def challenge_weight(challenge)
    if params.has_key?(:meta_challenge_id)
      challenge_problem_mapping = Challenge.friendly.find(params[:meta_challenge_id]).challenge_problems.find_by(problem_id: challenge.id)
      return challenge_problem_mapping.weight if challenge_problem_mapping
    end
  end

  def detect_meta_challenge(challenge)
    return Challenge.friendly.find(params[:meta_challenge_id]) if is_current_page_meta_challenge_child(challenge)
  end

  def remaining_time_in_hours(challenge_round)
    (remaining_time_in_seconds(challenge_round) / (60 * 60)).floor
  end

  def remaining_time_in_days(challenge_round)
    (remaining_time_in_seconds(challenge_round) / (60 * 60 * 24)).floor
  end

  def remaining_time_in_seconds(challenge_round)
    return 0 if challenge_round.nil? || challenge_round.end_dttm.nil?

    seconds = challenge_round.end_dttm - Time.current
    seconds = 0 if seconds.nil? || seconds < 0
    seconds
  end

  def ending_dttm(challenge_round)
    return nil if challenge_round.nil?

    challenge_round.end_dttm.strftime('%d %b %H:%M UTC')
  end

  def formatted_count(counter)
    if counter > 10_000
      "#{format('%.1f', counter / 1000.0).chomp('.0')}k"
    else
      counter
    end
  end

  def resources_link(challenge)
    if challenge.clef_task.present?
      clef_task_task_dataset_files_path(challenge.clef_task, challenge_id: challenge.id)
    else
      challenge_dataset_files_path(challenge)
    end
  end

  def participants_link(challenge)
    if challenge.clef_task.present?
      clef_task_challenge_path(challenge)
    else
      challenge_participant_challenges_path(challenge)
    end
  end

  def submission_time(submission)
    submission.created_at.strftime('%a, %e %b %Y') + ' ' + submission.created_at.strftime('%H:%M:%S')
  end

  def is_current_page_meta_challenge_child(challenge)
    if params.has_key?('meta_challenge_id')
      if challenge.is_a?(String)
        return true if challenge != params['meta_challenge_id']
      elsif challenge.is_a?(Hash)
        return true if challenge.has_key?(:challenge_id) && (challenge[:challenge_id] != params['meta_challenge_id'])
      elsif challenge.slug != params['meta_challenge_id']
        return true
      end
    end
    false
  end

  def is_current_page_ml_challenge_child(challenge)
    if params.has_key?('ml_challenge_id')
      if challenge.is_a?(String)
        return true if challenge != params['ml_challenge_id']
      elsif challenge.is_a?(Hash)
        return true if challenge.has_key?(:challenge_id) && (challenge[:challenge_id] != params['ml_challenge_id'])
      elsif challenge.slug != params['ml_challenge_id']
        return true
      end
    end
    false
  end

  def meta_challenge(link, challenge)
    params_sub_challenge_id = params['meta_challenge_id'] || params['ml_challenge_id']

    challenge_child_action = params['meta_challenge_id'].present? ? is_current_page_meta_challenge_child(challenge) : is_current_page_ml_challenge_child(challenge)
    return challenge_path(params_sub_challenge_id) + link.gsub(%r{^/challenges}, '/problems') if challenge_child_action

    link
  end

  def sequence_num
    @challenge.persisted? ? @challenge.featured_sequence : next_sequence
  end

  def next_sequence
    max_seq = Challenge.maximum('featured_sequence') || Challenge.count
    max_seq + 1
  end

  # TODO: Generate below routes dynamically via meta programming
  def challenge_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_dataset_file_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_discussion_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_dynamic_contents_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_insights_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_leaderboards_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_newsletter_emails_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_participants_country_challenge_insights_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_submission_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_submissions_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_team_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_team_invitations_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_teams_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_winners_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def edit_challenge_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
   end

  def edit_challenge_dataset_file_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def export_challenge_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def filter_challenge_submissions_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def import_challenge_invitations_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def new_challenge_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def new_challenge_dataset_file_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def new_challenge_newsletter_emails_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def new_challenge_submission_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def remove_image_challenge_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def remove_invited_challenge_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def submissions_vs_time_challenge_insights_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def top_score_vs_time_challenge_insights_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_dataset_files_path(*args)
    path = super(*args)
    meta_challenge(path, args[0])
  end

  def challenge_end_time(challenge, active_round)
    (challenge_remaining_text(challenge, active_round) == 'Completed') || challenge_remaining_text(challenge, active_round) == 'Starting soon' ? '' : challenge.end_dttm
  end

  def challenge_round_end_time(challenge, challenge_round)
    challenge_remaining_text(challenge, challenge_round) == 'Completed' ? '' : challenge_round.end_dttm
  end

  private

  def challenge_submissions_count(challenge, parent_meta_challenge)
    if challenge.meta_challenge?
      all_challenge_ids = challenge.challenge_problems.pluck(:problem_id)

      formatted_count(Submission.where(challenge_id: all_challenge_ids, meta_challenge_id: challenge.id).count)
    elsif parent_meta_challenge.present?
      formatted_count(challenge.submissions.where(meta_challenge_id: parent_meta_challenge.id).count)
    else
      formatted_count(challenge.submissions.where(meta_challenge_id: nil).count)
    end
  end

  def challenge_participants_count(challenge, parent_meta_challenge)
    if parent_meta_challenge.present?
      formatted_count(parent_meta_challenge.challenge_participants.count)
    else
      formatted_count(challenge.challenge_participants.count)
    end
  end

  def challenge_teams_count(challenge, parent_meta_challenge)
    if parent_meta_challenge.present?
      formatted_count(parent_meta_challenge.teams.count)
    else
      formatted_count(challenge.teams.count)
    end
  end

  def challenge_page_views_count(challenge)
    formatted_count(challenge.page_views)
  end
end
