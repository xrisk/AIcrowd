module ChallengeRounds
  class CreateLeaderboardsService < ::BaseService
    def initialize(challenge_round:, meta_challenge_id: nil)
      @challenge_round       = challenge_round
      @challenge             = @challenge_round.challenge
      @submissions           = @challenge_round.submissions.reorder(created_at: :desc)
      @meta_challenge_id     = meta_challenge_id

      if @meta_challenge_id.blank?
        @team_participants_ids = @challenge.team_participants.pluck(:participant_id)
        @team_challenge_id     = @challenge.id
      else
        @team_participants_ids = Challenge.find(@meta_challenge_id).team_participants.pluck(:participant_id)
        @team_challenge_id     = @meta_challenge_id
      end
    end

    def call
      ActiveRecord::Base.transaction do
        truncate_scores

        BaseLeaderboard.where(challenge_round: challenge_round, meta_challenge_id: meta_challenge_id).delete_all

        leaderboards          = build_base_leaderboards('leaderboard', [false], Time.current)
        previous_leaderboards = build_base_leaderboards('leaderboard', [false], window_border_dttm([false]))

        create_leaderboards(leaderboards, previous_leaderboards)

        ongoing_leaderboards          = build_base_leaderboards('ongoing', [true, false], Time.current)
        previous_ongoing_leaderboards = build_base_leaderboards('ongoing', [true, false], window_border_dttm([true, false]))

        create_leaderboards(ongoing_leaderboards, previous_ongoing_leaderboards)
      end

      success
    end

    private

    attr_reader :challenge_round, :challenge, :submissions, :window_border, :meta_challenge_id, :team_participants_ids, :team_challenge_id

    def truncate_scores
      submissions
        .where(meta_challenge_id: meta_challenge_id)
        .update_all([
          'score_display = ROUND(score::numeric, ?), score_secondary_display = ROUND(score_secondary::numeric, ?)',
          @challenge_round.score_precision,
          @challenge_round.score_secondary_precision
        ])
    end

    def build_base_leaderboards(leaderboard_type, post_challenge, cuttoff_dttm)
      users_leaderboards = []

      teams_submissions(post_challenge, cuttoff_dttm).each do |team_id, submissions|
        first_graded_submission = submissions.find { |submission| submission.grading_status_cd == 'graded' }
        next if first_graded_submission.blank?

        users_leaderboards << build_leaderboard(first_graded_submission, submissions.size, 'Team', team_id, leaderboard_type)
      end

      participants_submissions(post_challenge, cuttoff_dttm).each do |participant_id, submissions|
        first_graded_submission = submissions.find { |submission| submission.grading_status_cd == 'graded' }
        next if first_graded_submission.blank?

        users_leaderboards << build_leaderboard(first_graded_submission, submissions.size, 'Participant', participant_id, leaderboard_type)
      end

      migration_submmissions(post_challenge, cuttoff_dttm).each do |submission|
        users_leaderboards << build_leaderboard(submission, 1, 'OldParticipant', nil, leaderboard_type)
      end

      baseline_leaderboards = baseline_submissions(post_challenge, cuttoff_dttm).map do |submission|
        build_leaderboard(submission, 0, 'Participant', submission.participant_id, leaderboard_type)
      end

      assign_row_num(users_leaderboards)

      all_leaderboards    = users_leaderboards + baseline_leaderboards
      sorted_leaderboards = sort_leaderboards(all_leaderboards)

      sorted_leaderboards.each.with_index(1) do |leaderboard, index|
        leaderboard.seq = index
        leaderboard
      end

      sorted_leaderboards
    end

    def create_leaderboards(leaderboards, previous_leaderboards)
      leaderboards.each do |leaderboard|
        previous_leaderboard = previous_leaderboards.find do |previous_leaderboard|
          previous_leaderboard.submitter_id == leaderboard.submitter_id &&
          previous_leaderboard.submitter_type == leaderboard.submitter_type
        end

        next if previous_leaderboard.blank?

        leaderboard.previous_row_num = previous_leaderboard.row_num
      end

      BaseLeaderboard.import!(leaderboards)
    end

    def teams_submissions(post_challenge, cuttoff_dttm)
      submissions.joins(participant: :teams)
        .where(teams: { challenge_id: team_challenge_id })
        .where(challenge_round_id: challenge_round.id, meta_challenge_id: meta_challenge_id, post_challenge: post_challenge, baseline: false)
        .where('submissions.created_at <= ?', cuttoff_dttm)
        .select('teams.id AS team_id, submissions.*')
        .reorder(submissions_order)
        .group_by { |submission| submission.team_id }
    end

    def participants_submissions(post_challenge, cuttoff_dttm)
      submissions.joins(:participant)
        .where.not(participant_id: team_participants_ids)
        .where(challenge_round_id: challenge_round.id, meta_challenge_id: meta_challenge_id, post_challenge: post_challenge, baseline: false)
        .where('submissions.created_at <= ?', cuttoff_dttm)
        .reorder(submissions_order)
        .group_by { |submission| submission.participant_id }
    end

    def migration_submmissions(post_challenge, cuttoff_dttm)
      submissions.left_joins(:participant)
        .where(challenge_round_id: challenge_round.id, meta_challenge_id: meta_challenge_id, post_challenge: post_challenge, baseline: false, grading_status_cd: 'graded')
        .where('submissions.created_at <= ?', cuttoff_dttm)
        .reorder(submissions_order)
        .where('participants.id IS NULL')
    end

    def baseline_submissions(post_challenge, cuttoff_dttm)
      challenge_round.submissions
        .where(challenge_round_id: challenge_round.id, meta_challenge_id: meta_challenge_id, post_challenge: post_challenge, baseline: true, grading_status_cd: 'graded')
        .where('submissions.created_at <= ?', cuttoff_dttm)
    end

    def build_leaderboard(submission, submissions_count, submitter_type, submitter_id, leaderboard_type = 'leaderboard')
      BaseLeaderboard.new(
        meta_challenge_id:    meta_challenge_id,
        challenge_id:         challenge.id,
        challenge_round_id:   challenge_round.id,
        submitter_type:       submitter_type,
        submitter_id:         submitter_id,
        submission_id:        submission.id,
        seq:                  0,
        row_num:              0,
        previous_row_num:     0,
        entries:              submissions_count,
        score:                submission.score_display,
        score_secondary:      submission.score_secondary_display,
        meta:                 submission.meta,
        media_large:          submission.media_large,
        media_thumbnail:      submission.media_thumbnail,
        media_content_type:   submission.media_content_type,
        description:          submission.description,
        description_markdown: submission.description_markdown,
        leaderboard_type_cd:  leaderboard_type,
        post_challenge:       submission.post_challenge,
        baseline:             submission.baseline,
        baseline_comment:     submission.baseline_comment,
        refreshed_at:         Time.current,
        created_at:           submission.created_at,
        updated_at:           submission.updated_at
      )
    end

    def sort_map(sort_field)
      case sort_field
      when 'ascending'
        return 'asc'
      when 'descending'
        return 'desc'
      else
        return nil
      end
    end

    def submissions_order
      return 'updated_at desc' if challenge.latest_submission == true

      score_sort_order = sort_map(challenge_round.primary_sort_order_cd)

      return "score_display #{score_sort_order} NULLS LAST" if challenge_round.secondary_sort_order_cd.blank? || challenge_round.secondary_sort_order_cd == 'not_used'

      secondary_sort_order = sort_map(challenge_round.secondary_sort_order_cd)

      "score_display #{score_sort_order} NULLS LAST, score_secondary_display #{secondary_sort_order} NULLS LAST"
    end

    def sort_leaderboards(all_leaderboards)
      score_sort_order = sort_map(challenge_round.primary_sort_order_cd)

      if challenge_round.secondary_sort_order_cd.blank? || challenge_round.secondary_sort_order_cd == 'not_used'
        sorted_leaderboards = all_leaderboards.sort_by { |leaderboard| leaderboard.score.to_f }
        sorted_leaderboards.reverse! if score_sort_order == 'desc'

        return sorted_leaderboards
      end

      secondary_sort_order = sort_map(challenge_round.secondary_sort_order_cd)

      all_leaderboards.sort_by do |leaderboard|
        first_column     = score_sort_order == 'asc' ? leaderboard.score.to_f : leaderboard.score.to_f * -1
        secondary_column = secondary_sort_order == 'asc' ? leaderboard.score_secondary.to_f : leaderboard.score_secondary.to_f * -1

        [first_column, secondary_column]
      end
    end

    def assign_row_num(leaderboards)
      sorted_leaderboards = sort_leaderboards(leaderboards)

      current_row_num  = 1
      same_score_count = 0

      sorted_leaderboards.each.with_index do |leaderboard, index|
        leaderboard.row_num = current_row_num
        next_leaderboard    = sorted_leaderboards[index + 1]

        next if next_leaderboard.blank?

        if challenge_round.secondary_sort_order_cd.blank? || challenge_round.secondary_sort_order_cd == 'not_used'
          if next_leaderboard.score == leaderboard.score
            same_score_count += 1
          else
            current_row_num  += 1 + same_score_count
            same_score_count = 0
          end
        else
          if next_leaderboard.score == leaderboard.score && next_leaderboard.score_secondary == leaderboard.score_secondary
            same_score_count += 1
          else
            current_row_num  += 1 + same_score_count
            same_score_count = 0
          end
        end
      end
    end

    def window_border_dttm(post_challenge)
      (submissions.find_by(post_challenge: post_challenge, meta_challenge_id: meta_challenge_id)&.created_at || Time.current) - challenge_round.ranking_window.hours
    end
  end
end
