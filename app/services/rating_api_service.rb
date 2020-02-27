class RatingApiService
  include HTTParty
  debug_output $stdout
  base_uri ENV["RATING_API_URL"]
  default_params output: 'json'
  format :json

  def call(ranks, teams_mu, teams_sigma, teams_participant_ids)
    body = {
        ranks: ranks,
        teams_mu: teams_mu,
        teams_sigma: teams_sigma,
        teams_participant_ids: teams_participant_ids
    }.to_json
    headers = { 'Content-Type' => 'application/json' }
    # Add http://localhost:8888/calculate for local testing of the api
    begin
      result = self.class.post('/calculate', body: body, headers: headers)
    rescue HTTParty::Error => e
      Rails.logger.error e.message
    rescue StandardError => e
          Rails.logger.error e.message
    else
      case result.code
      when 500...600
        Rails.logger.error "ERROR #{result.code} #{result.parsed_response}"
      end
      return result.parsed_response['final_rating'], result.parsed_response['final_variation']
    end
  end
end