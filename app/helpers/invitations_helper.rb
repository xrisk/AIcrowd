module InvitationsHelper
  def invitation_amount_of_other_people(team)
    other_team_member_count = team.team_participants.count - 1

    "#{other_team_member_count} other #{other_team_member_count == 1 ? 'person' : 'people'}"
  end

  def invitation_team_members(team)
    team_members_count = team.team_participants.count

    "#{team_members_count} #{team_members_count == 1 ? 'member' : 'members'}"
  end

  def invitation_team_link(team)
    if team.persisted?
      link_to team.name, challenge_team_url(team.challenge, team), target: '_blank'
    else
      "“#{team.name}”"
    end
  end

  def invitation_invitee_link(invitee)
    case invitee
    when Participant
      content_tag(:span, 'Participant ') +
        link_to(invitee.name, participant_url(invitee), target: '_blank')
    when EmailInvitation
      content_tag(:span, 'Participant ') +
        mail_to(invitee.email, invitee.email.sub(/@.+\z/, ''))
    else
      content_tag(:span, '&lt;?&gt;')
    end
  end

  def invitation_button(text, team_invitation, invitee, primary, type)
    url_params = [team_invitation]
    url_params << { email_token: invitee.display_token } if invitee.is_a?(EmailInvitation)

    border  = primary ? '0' : '1px solid #aaacad'
    bg      = primary ? '#f0524d' : '#ffffff'
    color   = primary ? '#ffffff' : '#292c2d'

    span_style = <<~STYLE
      display: inline-block;
      min-width: 70px;
      border: #{border};
      background-color: #{bg};
      color: #{color};
      border-radius: 100px;
      font-family: Arial;
      font-size: 20px;
      font-weigth: 600;
      line-height: 1.4;
      padding: 10px 30px;
    STYLE

    if type == 'invite'
      link_to team_invitation_acceptances_url(*url_params), style: 'text-decoration: none;' do
        content_tag(:span, text, style: span_style)
      end
    elsif type == 'decline'
      link_to team_invitation_declinations_url(*url_params), style: 'text-decoration: none;' do
        content_tag(:span, text, style: span_style)
      end
    end
  end
end
