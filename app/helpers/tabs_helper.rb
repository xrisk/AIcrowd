module TabsHelper
  def tab_class(tab)
    tab == current_tab ? 'active' : ''
  end

  def round_pills_tab_classes(challenge_round, current_round)
    if challenge_round.id == current_round.id
      return 'nav-link active'
    else
      return 'nav-link'
    end
  end

  private

  def current_tab
    case controller.controller_name
    when 'challenges'
      'Overview'
    when 'leaderboards'
      'Leaderboard'
    when 'topics'
      'Discussion'
    when 'dataset_files'
      'Resources'
    when 'task_dataset_files'
      'Resources'
    when 'insights'
      'Insights'
    when 'participant_challenges'
      'Participants'
    when 'winners'
      'Winners'
    when 'dynamic_contents'
      challenge.dynamic_content_tab
    when 'submissions'
      'Submissions'
    when 'clef_tasks'
      'Tasks'
    when 'organizers'
      'Challenges'
    when 'members'
      'Members'
    when 'challenge_rules'
      'Rules'
    end
  end
end
