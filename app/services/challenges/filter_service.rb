module Challenges
  class FilterService

    def initialize(params, challenges)
      @params = params
      @challenges = challenges
    end

    def call
      # category filter
      @challenges = @challenges.joins(:categories).group('challenges.id').where('categories.name IN (?)', @params[:category]['category_names']) if @params.dig(:category, 'category_names').present?
      # status filter
      @challenges = @challenges.where(status_cd: @params[:status]) if @params[:status].present?
      # prize filter
      @challenges = @challenges.where.not(prize_cash: nil) if @params.dig(:prize, 'prize_type')&.include?('prize_cash')
      @challenges = @challenges.where.not(prize_travel: nil) if @params.dig(:prize, 'prize_type')&.include?('prize_travel')
      @challenges = @challenges.where.not(prize_academic: nil) if @params.dig(:prize, 'prize_type')&.include?('prize_academic')
      @challenges = @challenges.where.not(prize_misc: nil) if @params.dig(:prize, 'prize_type')&.include?('prize_misc')
      # return filtered challenges
      @challenges
    end
  end
end
