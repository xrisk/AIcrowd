class CalculateMetaLeaderboardService
  def initialize(challenge_id:)
    @challenge = Challenge.find(challenge_id)

    raise Exception, 'This service should only be called for meta or ml challenges' if !@challenge.meta_challenge && !@challenge.ml_challenge

    @round = @challenge.active_round

    @child_leaderboards = []
    @weight_hash        = {}

    @challenge.challenge_problems.each do |challenge_problem|
      @weight_hash[challenge_problem.challenge_round_id] = challenge_problem.weight
      child_leaderboard                                  = if @challenge.ml_challenge
                                                             ChallengeRound.find(challenge_problem.challenge_round_id).leaderboards.where(ml_challenge_id: challenge_id)
                                                           else
                                                             ChallengeRound.find(challenge_problem.challenge_round_id).leaderboards.where(meta_challenge_id: challenge_id)
                          end
      @child_leaderboards.append(child_leaderboard) if child_leaderboard.present?
    end
  end

  def call
    start_time = Time.zone.now
    create_leaderboard if @child_leaderboards.present?
    now        = Time.zone.now
    Rails.logger.info "Calculated leaderboard for round #{@round.id} in #{format('%0.3f', (now - start_time).to_f)}s."
    true
  end

  private

  def ranking_formula(rank, challenge_round_id, submitter_id = nil)
    if @challenge.ml_challenge
      @challenge.challenge_problems.find_by(challenge_round_id: challenge_round_id).problem.ml_activity_points.where(participant_id: submitter_id).sum_points
    else
      rank * @weight_hash[challenge_round_id]
    end
  end

  def common_values
    {
      challenge_id:        @challenge.id,
      challenge_round_id:  @round.id,
      leaderboard_type_cd: 'leaderboard',
      post_challenge:      false
    }
  end

  def participant_values(rank, participant, scores)
    {
      row_num:          rank,
      previous_row_num: rank, # TODO: show progress
      entries:          scores['entries'],
      score:            scores['score'],
      score_secondary:  0,
      submission_id:    scores['submission_id'],
      seq:              rank,
      meta:             scores['rank'],
      submitter_type:   participant[0],
      submitter_id:     participant[1]
    }
  end

  def create_leaderboard
    people = {}
    @child_leaderboards.each do |child_leaderboard|
      child_leaderboard.each do |entry|
        key                                              = [entry['submitter_type'], entry['submitter_id']]
        unless people.has_key?(key)
          people[key]                  = {}
          people[key]['rank']          = {}
          people[key]['score']         = 0.0
          people[key]['entries']       = 0
          people[key]['submission_id'] = entry['submission_id']
        end
        people[key]['rank'][entry['challenge_round_id']] = { position: entry['row_num'], score: entry['score'] }
        people[key]['score']                            += ranking_formula(entry['row_num'], entry['challenge_round_id'], entry['submitter_id'])
        people[key]['entries']                          += entry['entries']
      end
    end

    worst_rank              = people.keys.length
    all_challenge_round_ids = @weight_hash.keys
    people.each do |submittor, standing|
      challenge_round_not_participated = all_challenge_round_ids - standing['rank'].keys
      challenge_round_not_participated.each do |challenge_round|
        people[submittor]['score'] += ranking_formula(worst_rank, challenge_round)
      end
    end

    BaseLeaderboard.where(challenge_id: @challenge.id, challenge_round_id: @round.id).delete_all
    rank       = @challenge.ml_challenge ? people.size : 0
    last_score = -1

    people.sort_by { |_k, v| v['score'] }.each do |key, value|
      if value['score'] > last_score
        rank       = @challenge.ml_challenge ? rank -= 1 : rank += 1
        last_score = value['score']
      end
      obj = BaseLeaderboard.new(common_values.merge(participant_values(rank, key, value)))
      obj.save!
    end
  end
end
