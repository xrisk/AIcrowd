module Organizers
  class InvitationsMailer < StandardApplicationMailer
    add_template_helper(InvitationsHelper)

    def accepted_notification_email(participant, team_invitation)
      @participant           = participant
      @team                  = team_invitation.team
      @invitee               = team_invitation.invitee
      @email_preferences_url = EmailPreferencesTokenService.new(@participant).preferences_token_url
      subject                = '[AIcrowd] Team Invitation Accepted'

      mail(to: @participant.email, subject: subject)
    end
  end
end
