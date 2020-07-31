class SubmissionsRemainingQuery
  def initialize(challenge:, participant_id:)
    @challenge      = challenge
    @participant_id = participant_id
  end

  # returns:
  # submissions remaining
  # reset dttm
  # array of submissions already made in this period

  def call
    return [1, nil, []] unless @challenge.running? && @challenge.active_round.present?

    case @challenge.active_round.submission_limit_period_cd.to_s
    when 'day'
      day_amount
    when 'week'
      week_amount
    when 'round'
      round_amount
    end
  end

  private

  attr_reader :challenge, :participant_id

  def day_amount
    submissions = @challenge.submissions
                            .where('participant_id IN (?) and created_at >= ?', team_participants_ids, Time.zone.now - 24.hours)
                            .order(created_at: :asc)

    if submissions.blank?
      [@challenge.active_round.submission_limit, nil, previous_submissions(submissions: submissions)]
    else
      failed_submission_count = @challenge.submissions
                                          .where("grading_status_cd = 'failed' and participant_id IN (?) and created_at >= ?",
                                                 team_participants_ids,
                                                 Time.zone.now - 24.hours)
                                          .count
      failed_adj              = [failed_submission_count, @challenge.active_round.failed_submissions.to_i].min

      [(@challenge.active_round.submission_limit - submissions.count + failed_adj),
       (submissions.first.created_at + 1.day).to_s,
       previous_submissions(submissions: submissions)]
    end
  end

  def week_amount
    submissions = @challenge.submissions
                            .where('participant_id IN (?) and created_at >= ?', team_participants_ids, Time.zone.now - 7.days)
                            .order(created_at: :asc)
    if submissions.blank?
      [@challenge.active_round.submission_limit, nil, previous_submissions(submissions: submissions)]
    else
      failed_submission_count = @challenge.submissions
                                          .where("grading_status_cd = 'failed' and participant_id IN (?) and created_at >= ?",
                                                 team_participants_ids,
                                                 Time.zone.now - 7.days)
                                          .count
      failed_adj              = [failed_submission_count, @challenge.active_round.failed_submissions.to_i].min
      [(@challenge.active_round.submission_limit - submissions.count + failed_adj),
       (submissions.first.created_at + 1.week).to_s,
       previous_submissions(submissions: submissions)]
    end
  end

  def round_amount
    submissions = @challenge.submissions
                            .where('post_challenge IS FALSE and participant_id IN (?) and challenge_round_id = ?',
                                   team_participants_ids,
                                   @challenge.active_round.id)
    if submissions.blank?
      [@challenge.active_round.submission_limit, nil, previous_submissions(submissions: submissions)]
    else
      failed_submission_count = @challenge.submissions
                                          .where("grading_status_cd = 'failed' and post_challenge IS FALSE"\
                                           ' and participant_id IN (?) and challenge_round_id = ?',
                                                 team_participants_ids,
                                                 @challenge.active_round.id)
                                          .count

      failed_adj = [failed_submission_count, @challenge.active_round.failed_submissions.to_i].min
      [(@challenge.active_round.submission_limit - submissions.count + failed_adj),
       nil,
       previous_submissions(submissions: submissions)]
    end
  end

  def previous_submissions(submissions:)
    submissions.map { |s| [s.id, s.grading_status_cd, s.created_at] }
  end

  def team_participants_ids
    team = challenge.teams.joins(:team_participants).find_by(team_participants: { participant_id: participant_id })

    if team.present?
      team.participants.pluck(:id)
    else
      [participant_id]
    end
  end
end
