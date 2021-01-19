module Admins
  class ExportChallengeSubmissionJob < ApplicationJob
    queue_as :default

    def perform(challenge_id, participant_id, challenge_round_id)
      challenge = Challenge.find_by_id(challenge_id)
      participant = Participant.find_by_id(participant_id)

      downloadable = challenge.submissions_downloadable || participant.admin?

      submissions = challenge.submissions
        .includes(:participant, :challenge_round)
        .where(challenge_round_id: challenge_round_id)


      csv_data = Submissions::CSVExportService.new(submissions: submissions, downloadable: downloadable).call.value

      Admin::NotificationsMailer.challenge_submissions_csv(csv_data, participant, challenge).deliver_later
    end
  end
end