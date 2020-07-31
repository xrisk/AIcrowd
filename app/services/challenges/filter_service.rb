module Challenges
  class FilterService
    def initialize(params, challenges)
      @params     = params
      @challenges = challenges
    end

    def call
      # category filter
      if @params.dig('categories').present?
        @challenges = @challenges.joins(:categories).group('challenges.id').where('categories.name IN (?)', @params['categories'].split(','))
      end
      # status filter
      @challenges = @challenges.where(status_cd: @params['status']) if @params['status'].present?
      # prize filter
      if @params['prizes'].present?
        @params['prizes'].split(',').each do |prize|
          @challenges = @challenges.public_send(prize)
        end
      end
      @challenges
    end
  end
end
