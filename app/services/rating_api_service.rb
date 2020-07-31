class RatingApiService
  include HTTParty
  debug_output $stdout
  base_uri ENV['RATING_API_URL']
  default_params output: 'json'
  format :json
  def call(challenge_rounds)
    body    = {
      rounds:     challenge_rounds,
      return_url: ENV['DOMAIN_NAME']
    }.to_json
    headers = { 'Content-Type' => 'application/json' }
    begin
      result = self.class.post('/startroundcalculations/', body: body, headers: headers)
    rescue HTTParty::Error => e
      Rails.logger.error e.message
    else
      case result.code
      when 500...600
        Rails.logger.error "ERROR #{result.code} #{result.parsed_response}"
      end
      [result.parsed_response['final_rating'], result.parsed_response['final_variation']]
    end
  end
end
