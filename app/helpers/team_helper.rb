module TeamHelper
  def team_creation_button(participant, challenge)
    if participant.teams.exists?(challenge_id: challenge.id)
      disabled = true
      title = "#{participant.name} is already on a team for this challenge"
    elsif !challenge.allows_team_changes?
      disabled = true
      title = "This challenge is currently not accepting new teams"
    else
      disabled = false
      title = "Create a team for this challenge"
    end

    content_tag(
      :span,
      title: title,
      class: 'pull-right mr-1',
      data: {
        toggle: 'tooltip',
      },
    ) do
      button_tag(
        'Create Team',
        type: 'button',
        disabled: disabled,
        class: 'btn btn-secondary btn-sm',
        data: {
          toggle: 'modal',
          target: '#create-team-modal',
        },
      )
    end
  end

  def team_member_invite_button(team)
    if policy(team).create_invitations?
      disabled = false
      title = 'Invite a new member to this team'
    else
      if current_participant.nil?
        title = 'You must be logged in to invite members to your team'
      elsif !team.organized_by?(current_participant)
        title = 'Only team organizers may invite members to the team'
      elsif !team.challenge.allows_team_changes?
        title = "The team's challenge is currently not allowing team modifications"
      else
        title = 'You may not invite new members at this time'
      end
      disabled = true
    end

    content_tag(
      :span,
      title: title,
      data: {
        toggle: 'tooltip',
      },
    ) do
      button_tag(
        'Invite member',
        type: 'button',
        disabled: disabled,
        class: 'btn btn-secondary',
        data: {
          toggle: 'modal',
          target: '#invite-team-member-modal',
        },
      )
    end
  end
end
