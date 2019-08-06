module TeamHelper
  def my_team_view_or_create_button(challenge)
    button_opts = {
      small: true,
      class: 'pull-right mr-1',
    }
    my_team = current_participant&.teams&.for_challenge(challenge)&.first

    if my_team
      button_opts[:title] = 'My Team'
      button_opts[:tooltip] = "View my team for this challenge: #{my_team.name}"
      button_opts[:link] = team_path(my_team)
    else
      button_opts[:title] = 'Create Team'
      create_team_failure_reason = {}
      if policy(challenge).create_team?(create_team_failure_reason)
        button_opts[:tooltip] = t(
          :allowed,
          scope: 'helpers.teams.create_button.tooltip',
        )
        button_opts[:modal] = '#create-team-modal'
      else
        button_opts[:disabled] = true
        button_opts[:tooltip] = t(
          create_team_failure_reason[:sym],
          scope: 'helpers.teams.create_button.tooltip',
          default: :unspecified,
        )
      end
    end

    themed_button(button_opts)
  end

  def team_invitation_cancel_button(invitation)
    if policy(invitation.team).cancel_invitations?
      title = 'Cancel this invitation'
      disabled = false
    else
      title = 'Only team organizers may cancel invitations to the team'
      disabled = true
    end

    if disabled
      button_tag(
        'Cancel',
        title: title,
        type: 'button',
        disabled: true,
        class: 'btn btn-sm btn-secondary',
        data: {
          toggle: 'tooltip',
        },
      )
    else
      link_to(
        'Cancel',
        team_invitation_cancellations_path(invitation),
        title: title,
        class: 'btn btn-sm btn-secondary',
        data: {
          method: :post,
          toggle: 'tooltip',
          confirm: 'Are you sure?',
          disable: 'Cancel',
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
      elsif team.challenge.teams_frozen?
        title = "The team's challenge has team-freeze in effect"
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
