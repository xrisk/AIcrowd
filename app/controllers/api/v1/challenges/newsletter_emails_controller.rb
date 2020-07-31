module Api
  module V1
    module Challenges
      class NewsletterEmailsController < ActionController::API
        DEFAULT_LIMIT = 100

        before_action :set_challenge, only: [:preview, :search]

        def search
          if params[:q].present?
            teams            = @challenge.teams.includes(:participants).where('teams.name ILIKE ?', "%#{params[:q]}%").limit(DEFAULT_LIMIT)
            participants     = @challenge.participants.where('participants.name ILIKE ?', "%#{params[:q]}%").limit(DEFAULT_LIMIT)
            challenge_rounds = @challenge.challenge_rounds.started.where('challenge_rounds.challenge_round ILIKE ?', "%#{params[:q]}%")
          else
            teams            = @challenge.teams.limit(DEFAULT_LIMIT)
            participants     = @challenge.participants.limit(DEFAULT_LIMIT)
            challenge_rounds = @challenge.challenge_rounds.started
          end

          search_result = SearchNewsletterEmailsSerializer.new(
            groups:           default_groups,
            teams:            teams,
            participants:     participants,
            challenge_rounds: challenge_rounds
          ).serialize

          render json: search_result, status: :ok
        end

        def preview
          newsletter_email = NewsletterEmail.new(newsletter_email_preview_params)

          if newsletter_email.valid?
            NewsletterEmailsMailer.organizer_email(newsletter_email).deliver_now
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

        def default_groups
          [].tap do |default_groups|
            default_groups << { id: :all_participants, text: 'All participants' } if 'All participants'.downcase.include?(params[:q].to_s.downcase)
            if 'Participants with submission'.downcase.include?(params[:q].to_s.downcase)
              default_groups << { id: :participants_with_submission, text: 'Participants with submission' }
            end
          end
        end
      end
    end
  end
end
