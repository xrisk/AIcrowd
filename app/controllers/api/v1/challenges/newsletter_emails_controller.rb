module Api
  module V1
    module Challenges
      class NewsletterEmailsController < ActionController::API
        before_action :set_challenge, only: :preview

        def preview
          newsletter_email = NewsletterEmail.new(newsletter_email_preview_params)

          if newsletter_email.valid?
            Organizers::NewsletterEmailMailer.new.sendmail(newsletter_email)
            head :ok
          else
            render json: { error: newsletter_email.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        end

        private

        def newsletter_email_preview_params
          params.require(:newsletter_email).permit(:subject, :message).merge(participant: current_participant, challenge: @challenge)
        end

        def set_challenge
          @challenge = Challenge.find(params[:challenge_id])
        end
      end
    end
  end
end
