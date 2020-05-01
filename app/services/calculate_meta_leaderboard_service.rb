class CalculateMetaLeaderboardService

  def initialize(challenge_id:)
    @challenge   = Challenge.find(challenge_id)
    if !@challenge.meta_challenge
      raise Exception.new('This service should only be called for meta challenges')
    end
    @round = @challenge.active_round

    @child_leaderboards = []
    @weight_hash = {}
    @challenge.challenge_problems.each do |challenge_problem|
      @weight_hash[challenge_problem.challenge_round_id] = challenge_problem.weight
      challenge_round = ChallengeRound.find(challenge_problem.challenge_round_id)
      if challenge_round.leaderboards.present?
        @child_leaderboards.append(challenge_round.leaderboards)
      end
    end
  end

  def call
    start_time = Time.zone.now
    if @child_leaderboards.present?
      #ActiveRecord::Base.transaction do
      create_leaderboard
      #end
    end
    now = Time.zone.now
    Rails.logger.info "Calculated leaderboard for round #{@round.id} in #{format('%0.3f', (now - start_time).to_f)}s."
    true
  end

  def common_values
    values = {
      challenge_id: @challenge.id,
      challenge_round_id: @round.id,
      leaderboard_type_cd: "leaderboard",
      post_challenge: false
    }
  end

  def participant_values(rank, participant, scores)
    values = {
      row_num: rank,
      previous_row_num: rank, #TODO: show progress
      entries: scores['entries'],
      score: scores['score'],
      score_secondary: 0,
      submission_id: scores['submission_id'],
      seq: rank,
      meta: scores['rank'],
      submitter_type: participant[0],
      submitter_id: participant[1]
    }
  end

  def total_weight
    @challenge.challenge_problems.pluck('weight').sum
  end

  def create_leaderboard
    people = {}
    @child_leaderboards.each do |child_leaderboard|
      child_leaderboard.each do |entry|
        key = [entry['submitter_type'], entry['submitter_id']]
        if !people.has_key?(key)
          people[key] = {}
          people[key]['rank'] = {}
          people[key]['score'] = 0.0
          people[key]['entries'] = 0
          people[key]['submission_id'] = entry['submission_id']
        end
        people[key]['rank'][entry['challenge_round_id']] = entry['seq']
        people[key]['score'] += (entry['seq'] * total_weight)/@weight_hash[entry['challenge_round_id']]
        people[key]['entries'] += entry['entries']
      end
    end

    BaseLeaderboard.where(challenge_id: @challenge.id, challenge_round_id: @round.id).delete_all
    rank = 0
    last_score = -1

    people.sort_by{|k, v| v['score']}.each do |key, value|
      if value['score'] > last_score
        rank += 1
      end
      obj = BaseLeaderboard.new(common_values.merge(participant_values(rank, key, value)))
      obj.save!
    end
  end

end
