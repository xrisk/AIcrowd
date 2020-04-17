module SubmissionBadges
  def create_submission_badges(participant_id)
    if grading_status_cd == 'graded'
      participant_submission_count = Submission.where(participant_id: participant_id, grading_status_cd: 'graded').count
      if participant_submission_count == 10
        Participant.find_by(id: participant_id).add_badge(9)
      elsif participant_submission_count == 100
        Participant.find_by(id: participant_id).add_badge(8)
      elsif participant_submission_count == 1000
        Participant.find_by(id: participant_id).add_badge(7)
      end
    end
    if Submission.where(participant_id: participant_id).count == 1
      Participant.find_by(id: participant_id)&.add_badge(13)
    end
    if Submission.where(participant_id: participant_id, grading_status_cd: 'graded').count == 1
      Participant.find_by(id: participant_id)&.add_badge(14)
    end
  end
end
