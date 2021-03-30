module Reputation
  class SyncChallengeRoundService

    def initialize
    end

    def call
      last_updated_time = get_last_updated_time
      sync_data(last_updated_time)
    end

    def get_last_updated_time
      response = HTTP.get("#{ENV['RATING_SANDBOX_URL']}/contest/get_update_time")
      contest = JSON.parse(response.body)
      contest["created_at"]
    end

    def sync_data(last_updated_time)
      challenge_rounds = ChallengeRound.where().where("created_at > ?", last_updated_time)
      # challenge_rounds = ChallengeRound.where(id: [164, 165])
      challenge_rounds = rename_keys(challenge_rounds.as_json)
      challenge_rounds.map{ |cr| cr.slice!("challenge_round_id", "name", "created_at") }
      challenge_rounds.map { |cr| cr.merge!(time_seconds: cr['created_at'].to_i)  }
      response = HTTP.post("#{ENV['RATING_SANDBOX_URL']}/contest/create", json: challenge_rounds)
      if response.status
        Reputation::SyncLeaderboardService.new.call
      end
    end

    def rename_keys params
      params.find().to_a.each do |param|
        param['challenge_round_id'] = param.delete 'id'
        param['name'] = param.delete 'challenge_round'
      end
    end
  end
end