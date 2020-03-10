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
    challenges = params[:category] && params[:category]['category_ids'].present? ? Challenge.joins(:categories).where('categories.id IN (?)', params[:category]['category_ids']) : challenges
    challenges = challenges.where(status_cd: params[:status]) if params[:status].present?
    if params[:prize].present?
      challenges = challenges.where.not(prize_cash: nil) if params[:prize]['prize_type'].include?('prize_cash')
      challenges = challenges.where.not(prize_travel: nil) if params[:prize]['prize_type'].include?('prize_travel')
      challenges = challenges.where.not(prize_academic: nil) if params[:prize]['prize_type'].include?('prize_academic')
      challenges = challenges.where.not(prize_misc: nil) if params[:prize]['prize_type'].include?('prize_misc')
    end
    challenges
  end
end
