module Reputation
  class SyncLeaderboardService

    def initialize
    end

    def call
      last_updated_time = get_last_updated_time
      sync_data(last_updated_time)
    end

    def get_last_updated_time
      response = HTTP.get("#{ENV['RATING_SANDBOX_URL']}/standing/get_update_time")
      # standing = JSON.parse(response.body)
      # standing["created_at"]
    end

    def sync_data(last_updated_time)
      # base_leaderboards = BaseLeaderboard.where("created_at > ?", last_updated_time))
      base_leaderboards = BaseLeaderboard.where(challenge_round_id: ChallengeRound.all.pluck(:id), leaderboard_type_cd: "leaderboard").where("submitter_id is not NULL").where("row_num is not NULL")
      base_leaderboards = rename_keys(base_leaderboards.as_json)
      base_leaderboards = base_leaderboards.map do |bl|
        if bl["challenge_round_id"] && bl["rank"] && bl["created_at"] && bl["participant_id"]
          {"challenge_round_id": bl["challenge_round_id"], "rank": (bl["rank"] - 1), "created_at": bl["created_at"], participant_id: bl["participant_id"]}
        end
      end
      base_leaderboards.delete_if { |h| h.blank? }
      response = HTTP.post("#{ENV['RATING_SANDBOX_URL']}/standing/create", json: base_leaderboards)
    end

    def rename_keys params
      params.find().to_a.each do |param|
        param['rank'] = param.delete 'row_num'
        param['participant_id'] = param.delete 'submitter_id'
      end
    end
  end
end