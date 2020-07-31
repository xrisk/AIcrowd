module Participants
  class InvitationsMailer < ApplicationMailer
    add_template_helper(InvitationsHelper)

    def invitation_accepted_email(team_invitation)
      set_participant_from_invitee(team_invitation.invitee)
      @team                  = team_invitation.team
      @email_preferences_url = EmailPreferencesTokenService.new(@participant).preferences_token_url if @participant.persisted?
      @notification_reason   = 'You joined a team.'
      subject                = "[AIcrowd] Welcome to Team #{@team.name}"

      mail(to: @participant.email, subject: subject)
    end

    def invitation_canceled_email(team_invitation)
      set_participant_from_invitee(team_invitation.invitee)
      @team                  = team_invitation.team
      @email_preferences_url = EmailPreferencesTokenService.new(@participant).preferences_token_url if @participant.persisted?
      @notification_reason   = 'Someone canceled your invitation to a team.'
      subject                = "[AIcrowd] Your Invitation to Team #{@team.name} Was Canceled"

      mail(to: @participant.email, subject: subject)
    end

    def invitation_pending_email(team_invitation)
      @team_invitation       = team_invitation
      @invitee               = @team_invitation.invitee
      @team                  = @team_invitation.team
      @invitor               = @team_invitation.invitor
      set_participant_from_invitee(@invitee)
      @email_preferences_url = EmailPreferencesTokenService.new(@participant).preferences_token_url if @participant.persisted?
      @notification_reason   = 'You’ve been invited to a team.'
      subject                = "[AIcrowd] Invitation to Team #{@team.name}"

      mail(to: @participant.email, subject: subject)
    end

    private

    def set_participant_from_invitee(invitee)
      case invitee
      when Participant
        @participant = invitee
      when EmailInvitation
        @participant = Participant.new(
          name:  invitee.email.sub(/@.*\z/, ''),
          email: invitee.email
        )
      else
        raise "Unexpected invitee type: #{@invitee.class}"
      end
    end
  end
end
