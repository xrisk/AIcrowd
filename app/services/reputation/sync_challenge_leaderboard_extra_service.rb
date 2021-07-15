module Reputation
  class SyncChallengeLeaderbaordExtraService

    def initialize
    end

    def call
      # last_updated_time = get_last_updated_time

      sync_data
    end

    def get_last_updated_time
      response = HTTP.get("#{ENV['RATING_SANDBOX_URL']}/contest/get_update_time", headers: {Authorization: "Bearer #{secure_data}"})
      contest = JSON.parse(response.body)
      contest["created_at"]
    end

    def secure_data
      payload = {fastapi: "aicrowd", access_key: "aicrowd_reputation_system"}
      JWT.encode(payload, ENV['REPUTATION_TOKEN'])
    end

    def sync_data
      challenge_leaderboard_extras_ids = [93,94,95,96,174,194,195,198,191,192,170,171,172,204,205,206,207,200,201,202,203,208,209,210,211,115,116,188,189,98,99,110,104,106,212,50,51,52,520,190,185,220,321,294,296,298,164,301,149,145,53,59,60,168,157,158,159,160,161,162,154,155,156,140,348,324,337,325,322,361,366,300,279,55,503,383,77,407,408,409,410,413,45,46,518,43,44,523,435,439,443,468,769,461,56,478,479,480,511,512,513,514,517,553,554,600,556,558,591,618,619,620,621,622,799,798,753,760,631,648,649,651,653,774,675,797,795,796,773,687,689,690,691,696,697,705,709,744,793,794,787,788,772,775,784,785,790,801,802,803,804]
      challenge_leaderboard_extras = ChallengeLeaderboardExtra.where(id: challenge_leaderboard_extras_ids).includes(:challenge_round)
      result = []
      challenge_leaderboard_extras.each do |cle|
        if cle.challenge_round
          result << {challenge_leaderboard_extra_id: cle.id, name: cle.challenge_round.challenge_round, created_at: cle.created_at, time_seconds: cle.created_at.to_i}
        end
      end
      response = HTTP.post("#{ENV['RATING_SANDBOX_URL']}/contest/create", json: result, headers: {Authorization: "Bearer #{secure_data}"})
      if response.status
        Reputation::SyncLeaderboardService.new.call
      end
    end

  end
end