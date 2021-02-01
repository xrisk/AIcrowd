module Admins
  class ExportChallengeSubmissionJob < ApplicationJob
    queue_as :default

    def perform(challenge_id, participant_id, leaderboard_id)
      @challenge = Challenge.find_by_id(challenge_id)
      @current_leaderboard = ChallengeLeaderboardExtra.find_by_id(leaderboard_id)
      challenge_round = ChallengeRound.find_by_id(@current_leaderboard.challenge_round_id)
      participant = Participant.find_by_id(participant_id)

      leaderboard_class = freeze_record_for_organizer ? 'OngoingLeaderboard' : 'Leaderboard'

      submission_ids = leaderboard_class.constantize
        .where(challenge_round_id: challenge_round.id)
        .where(challenge_leaderboard_extra_id: leaderboard_id)
        .pluck(:submission_id)



      downloadable = challenge.submissions_downloadable || participant.admin?

      submissions = Submission.where(id: submission_ids)


      csv_data = Submissions::CSVExportService.new(submissions: submissions, downloadable: downloadable).call.value

      Admin::NotificationsMailer.challenge_submissions_csv(csv_data, participant, challenge, challenge_round).deliver_later
    end

    def freeze_record_for_organizer
      return false unless @current_leaderboard&.freeze_flag

      (policy(@challenge).edit? || current_participant&.admin)
    end

  end
end