class CalculateMetaLeaderboardService

  def initialize(challenge_id:, challenge_leaderboard_extra: nil)
    @challenge = Challenge.find(challenge_id)

    if !@challenge.meta_challenge && !@challenge.ml_challenge
      raise Exception.new('This service should only be called for meta or ml challenges')
    end
    @round = @challenge.active_round
    @challenge_leaderboard_extra = challenge_leaderboard_extra
    if challenge_leaderboard_extra.nil?
      @challenge_leaderboard_extra = @round.default_leaderboard
    end

    @child_leaderboards = []
    @weight_hash = {}

    @challenge.challenge_problems.each do |challenge_problem|
      @weight_hash[challenge_problem.challenge_round_id] = challenge_problem.weight
      problem_challenge_round = ChallengeRound.find(challenge_problem.challenge_round_id)
      child_leaderboard = problem_challenge_round.leaderboards.where(meta_challenge_id: challenge_id, challenge_leaderboard_extra_id: [nil, problem_challenge_round.default_leaderboard.id])
      if child_leaderboard.present?
        @child_leaderboards.append(child_leaderboard)
      end
    end
  end

  def call
    start_time = Time.zone.now
    if @child_leaderboards.present?
      create_leaderboard
    end
    now = Time.zone.now
    Rails.logger.info "Calculated leaderboard for round #{@round.id} in #{format('%0.3f', (now - start_time).to_f)}s."
    true
  end

  private

  def ranking_formula(rank, challenge_round_id, submitter_id=nil)
    if @challenge.ml_challenge
      @challenge.challenge_problems.find_by(challenge_round_id: challenge_round_id).problem.ml_activity_points.where(participant_id: submitter_id).sum_points
    else
      rank * @weight_hash[challenge_round_id]
    end
  end

  def common_values
    {
      challenge_id: @challenge.id,
      challenge_round_id: @round.id,
      leaderboard_type_cd: "leaderboard",
      post_challenge: false
    }
  end

  def participant_values(rank, participant, scores)
    {
      row_num: rank,
      previous_row_num: rank, #TODO: show progress
      entries: scores['entries'],
      score: scores['score'],
      score_secondary: 0,
      submission_id: scores['submission_id'],
      seq: rank,
      meta: scores['rank'],
      submitter_type: participant[0],
      submitter_id: participant[1],
      challenge_leaderboard_extra_id: @challenge_leaderboard_extra.id
    }
  end

  def create_leaderboard
    people = {}
    @child_leaderboards.each do |child_leaderboard|
      filter = child_leaderboard&.first&.challenge_leaderboard_extra&.filter
      child_leaderboard = child_leaderboard.joins(:participant).where(filter) if filter.present?
      child_leaderboard.each do |entry|
        key = [entry['submitter_type'], entry['submitter_id']]
        if !people.has_key?(key)
          people[key] = {}
          people[key]['rank'] = {}
          people[key]['score'] = 0.0
          people[key]['entries'] = 0
          people[key]['submission_id'] = entry['submission_id']
        end
        people[key]['rank'][entry['challenge_round_id']] = {position: entry['row_num'], score: entry['score']}
        people[key]['score'] += ranking_formula(entry['row_num'], entry['challenge_round_id'], entry['submitter_id'])
        people[key]['entries'] += entry['entries']
      end
    end

    worst_rank = people.keys.length
    all_challenge_round_ids = @weight_hash.keys
    people.each do |submittor, standing|
      challenge_round_not_participated = all_challenge_round_ids - standing['rank'].keys
      challenge_round_not_participated.each do |challenge_round|
        people[submittor]['score'] += ranking_formula(worst_rank, challenge_round)
      end
    end

    delete_leaderboards

    rank       = @challenge.ml_challenge ? people.size : 0
    last_score = -1

    people.sort_by { |k, v| v['score'] }.each do |key, value|
      if value['score'] > last_score
        rank       = @challenge.ml_challenge ? rank -= 1 : rank += 1
        last_score = value['score']
      end
      obj = BaseLeaderboard.new(common_values.merge(participant_values(rank, key, value)))
      obj.save!
    end
  end

  def delete_leaderboards
    entries = BaseLeaderboard.where(challenge_id: @challenge.id, challenge_round_id: @round.id)

    if @challenge_leaderboard_extra.default
      entries = entries.where(challenge_leaderboard_extra_id: [nil, @challenge_leaderboard_extra.id])
    else
      entries = entries.where(challenge_leaderboard_extra_id: @challenge_leaderboard_extra.id)
    end

    entries.delete_all
  end

end
