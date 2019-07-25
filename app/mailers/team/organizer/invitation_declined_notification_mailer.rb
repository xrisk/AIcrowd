# frozen_string_literal: true
class Team::Organizer::InvitationDeclinedNotificationMailer < Team::BaseMailer
  def sendmail(participant_id:, team_id:, invitee_id:)
    @participant = Participant.find(participant_id)
    @team = Team.find(team_id)
    @invitee = Participant.find(invitee_id)
    mandrill_send(format_options)
  end

  def email_subject
    'Team Invitation Declined'
  end

  def email_body_html
    <<~HTML
      <div>
        <p>Participant #{linked_invitee_html} just declined an invitation to join Team #{linked_team_html}.</p>
        #{signoff_html}
      </div>
    HTML
  end

  def notification_reason
    'Someone declined an invitation to a team you organize.'
  end
end
