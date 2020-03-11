module ChallengeFilter
  extend ActiveSupport::Concern

  def set_filters
    @categories = Category.all
    @status     = Challenge.statuses.keys
    @prize_hash = { prize_cash:     'Cash prizes',
                    prize_travel:   'Travel grants',
                    prize_academic: 'Academic papers',
                    prize_misc:     'Misc prizes' }
  end

  def filter_challenge(challenges = nil)
    # category filter
    challenges = category? ? Challenge.joins(:categories).where('categories.id IN (?)', params[:category]['category_ids']) : all_list(challenges)
    # status filter
    challenges = challenges.where(status_cd: params[:status]) if params[:status].present?
    # prize filter
    challenges = challenges.where.not(prize_cash: nil) if params.dig(:prize, 'prize_type')&.include?('prize_cash')
    challenges = challenges.where.not(prize_travel: nil) if params.dig(:prize, 'prize_type')&.include?('prize_travel')
    challenges = challenges.where.not(prize_academic: nil) if params.dig(:prize, 'prize_type')&.include?('prize_academic')
    challenges = challenges.where.not(prize_misc: nil) if params.dig(:prize, 'prize_type')&.include?('prize_misc')
    # return filtered challenges
    challenges
  end

  private

  def category?
    params.dig(:category, 'category_ids').present?
  end

  def all_list(challenges)
    challenges || Challenge.all
  end
end
