module Challenges
  class NewsletterEmailsController < ApplicationController
    include Concerns::ChallengeMasthead
    challenge_masthead_actions [:new, :create]

    before_action :set_newsletter_email_groups, only: [:new, :create]

    def new
      @newsletter_email_form = NewsletterEmailForm.new(challenge: @challenge, participant: current_participant)
      authorize @newsletter_email_form
    end

    def create
      @newsletter_email_form = NewsletterEmailForm.new(newsletter_email_form_params.merge(challenge: @challenge, participant: current_participant))
      authorize @newsletter_email_form

      if current_participant.trusted?
        flash_message = { notice: 'E-mail has been sent to the participants' }
      else
        flash_message = { notice: 'E-mail will be sent to participants after admin approval' }
      end

      if @newsletter_email_form.save
        redirect_to new_challenge_newsletter_emails_path(@challenge), flash: flash_message
      else
        flash.now[:error] = @newsletter_email_form.errors.full_messages.to_sentence
        render :new
      end
    end

    private

    def set_newsletter_email_groups
      @newsletter_email_groups = default_groups + challenge_rounds_groups
    end

    def default_groups
      [
        ['All participants', :all_participants],
        ['Participants with submission', :participants_with_submission]
      ]
    end

    def challenge_rounds_groups
      @challenge_rounds.map do |challenge_round|
        [
          "Participants of \"#{challenge_round.challenge_round}\"",
          challenge_round.id
        ]
      end
    end

    def newsletter_email_form_params
      params.require(:newsletter_email_form).permit(:cc, :bcc, :subject, :message, multi_select: [])
    end
  end
end
