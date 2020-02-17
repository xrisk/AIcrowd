module TabsHelper
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

  def tab_class(tab)
    tab == current_tab ? 'active' : ''
  end
end
