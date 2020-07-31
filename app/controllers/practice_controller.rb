class PracticeController < ApplicationController
  before_action :set_filters, only: [:index]

  respond_to :html, :js

  def index
    @all_challenges      = policy_scope(Challenge)
    @practice_challenges = @all_challenges.practice
    @practice_challenges = Challenges::FilterService.new(params, @practice_challenges).call
    @editor_challenges   = @practice_challenges.editors_selections
    @practice_challenges = @practice_challenges.not_editors_selections.page(params[:page]).per(16)
  end

  private

  def set_filters
    @categories = Category.all
    @status     = challenge_status
    @prize_hash = { prize_cash:     'Cash prizes',
                    prize_travel:   'Travel grants',
                    prize_academic: 'Academic papers',
                    prize_misc:     'Misc prizes' }
  end

  def challenge_status
    params[:controller] == 'landing_page' ? Challenge.statuses.keys - ['draft'] : Challenge.statuses.keys
  end
end
