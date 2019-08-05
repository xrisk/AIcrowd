# frozen_string_literal: true
class Team::Invitee::InvitationPendingNotificationMailer < Team::BaseMailer
  def sendmail(invitation)
    @invitation = invitation
    @participant = @invitation.invitee
    @team = @invitation.team
    @invitor = @invitation.invitor
    mandrill_send(format_options)
  end

  def email_subject
    "Invitation to Team"
  end

  def email_body_html
    team_member_count = @team.team_participants.count
    n_members = "#{team_member_count} #{team_member_count == 1 ? 'member' : 'members'}"
    <<~HTML
      <div>
        <p>You’ve been invited to join Team #{linked_team_html}!</p>
        <p>
          Participant #{linked_invitor_html} has invited you to collaborate on Challenge
          #{linked_challenge_html}. The team currently has #{n_members}.
        </p>
        <p>Accepting this invitation will have the following effects <b>for this challenge only</b>:</p>
        <ul>
          <li>You will be a member of #{linked_team_html} for the duration of the challenge</li>
          <li>All team members will share equal leaderboard spots and prizes</li>
          <li>You may only be a member of a single team per challenge</li>
        </ul>
        <p style="text-align: center;">
          #{button_html('Join!', team_invitation_acceptances_url(@invitation), true)}
          <span style="margin-right: 20px"></span>
          #{button_html('Decline', team_invitation_declinations_url(@invitation), false)}
        </p>
        #{signoff_html}
      </div>
    HTML
  end

  def notification_reason
    'You’ve been invited to a team.'
  end

  private def button_html(text, url, primary)
    border =  primary ? '0'       : '1px solid #aaacad'
    bg =      primary ? '#f0524d' : '#ffffff'
    color =   primary ? '#ffffff' : '#292c2d'
    a_style = <<~STYLE
      text-decoration: none;
    STYLE
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

    <<~HTML
      <a href="#{url}" style="#{a_style}"><span style="#{span_style}">#{text}</span></a>
    HTML
  end
end
