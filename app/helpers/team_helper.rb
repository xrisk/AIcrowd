module TeamHelper
  def my_team_view_or_create_button(challenge)
    if challenge.teams_allowed
      button_opts = {
          small: true,
          class: 'pull-right mr-1',
      }
      my_team = current_participant&.teams&.for_challenge(challenge)&.first

      if my_team
        button_opts[:title] = 'My Team'
        button_opts[:tooltip] = "View my team for this challenge: #{my_team.name}"
        button_opts[:link] = challenge_team_path(challenge, my_team)
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
  end

  def team_invitation_cancel_button(invitation)
    button_opts = {
        title: 'Cancel',
        link: {
            url: team_invitation_cancellations_path(invitation),
            method: :post,
        },
        confirm: 'Are you sure?',
        small: true,
    }
    if policy(invitation.team).cancel_invitations?
      button_opts[:tooltip] = 'Cancel this invitation'
    else
      button_opts[:tooltip] = 'Only team organizers may cancel invitations to the team'
      button_opts[:disabled] = true
    end

    themed_button(button_opts)
  end

  def team_member_invite_button(team)
    button_opts = {
        title: 'Invite member',
        modal: '#invite-team-member-modal',
    }
    if policy(team).create_invitations?
      button_opts[:tooltip] = 'Invite a new member to this team'
    else
      button_opts[:disabled] = true
      if current_participant.nil?
        button_opts[:tooltip] = 'You must be logged in to invite members to your team'
      elsif team.invitations_left == 0
        button_opts[:tooltip] = 'No more invitations left'
      elsif !team.organized_by?(current_participant)
        button_opts[:tooltip] = 'Only team organizers may invite members to the team'
      elsif team.challenge.teams_frozen?
        button_opts[:tooltip] = "The team's challenge has team-freeze in effect"
      else
        button_opts[:tooltip] = 'You may not invite new members at this time'
      end
    end

    themed_button(button_opts)
  end
end
