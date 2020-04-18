module Challenges
  class FilterService

    def initialize(params, challenges)
      @params = params
      @challenges = challenges
    end

    def call
      # category filter
      @challenges = @challenges.joins(:categories).where('categories.name IN (?)', @params['categories'].split(',')) if @params.dig('categories').present?
      # status filter
      @challenges = @challenges.where(status_cd: @params['status']) if @params['status'].present?
      # prize filter
      if @params['prizes'].present?
        @params['prizes'].split(',').each do |prize|
          @challenges = @challenges.send(prize)
        end
      end
      @challenges
    end
  end
end
