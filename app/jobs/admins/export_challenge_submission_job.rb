module Admins
  class ExportChallengeSubmissionJob < ApplicationJob
    queue_as :default

    def perform(challenge_id, participant_id, leaderboard_id=nil, challenge_round_id=nil)
      @challenge = Challenge.find_by_id(challenge_id)
      participant = Participant.find_by_id(participant_id)

      unless leaderboard_id.zero?
        @current_leaderboard = ChallengeLeaderboardExtra.find_by_id(leaderboard_id)
        challenge_round = ChallengeRound.find_by_id(@current_leaderboard.challenge_round_id)

        leaderboard_class = freeze_record_for_organizer ? 'OngoingLeaderboard' : 'Leaderboard'

        submission_ids = leaderboard_class.constantize
          .where(challenge_round_id: challenge_round.id)
          .where(challenge_leaderboard_extra_id: leaderboard_id)
          .pluck(:submission_id)

        submissions = Submission.includes(:participant, :challenge_round).where(id: submission_ids)
      else
        challenge_round = ChallengeRound.find_by_id(challenge_round_id)
        submissions = @challenge.submissions
        .includes(:participant, :challenge_round)
        .where(challenge_round_id: challenge_round_id)
      end

      downloadable = @challenge.submissions_downloadable || participant.admin?

      csv_data = Submissions::CSVExportService.new(submissions: submissions, downloadable: downloadable).call.value

      Admin::NotificationsMailer.challenge_submissions_csv(csv_data, participant, @challenge, challenge_round).deliver_later
    end

    def freeze_record_for_organizer
      return false unless @current_leaderboard&.freeze_flag

      (policy(@challenge).edit? || current_participant&.admin)
    end

  end
end