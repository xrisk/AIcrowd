class SearchesController < ApplicationController
  DEFAULT_LIMIT = 6

  def show
    @challenges        = policy_scope(Challenge).where('challenge ILIKE ? OR description ILIKE ?', "%#{params[:q]}%", "%#{params[:q]}%").limit(DEFAULT_LIMIT)
    @participants      = Participant.where('name ILIKE ?', "%#{params[:q]}%").limit(DEFAULT_LIMIT)
    @discussions_fetch = Rails.cache.fetch("discourse-search-discussions/#{params[:q]}", expires_in: 5.minutes) do
      Discourse::FetchSearchResultsService.new(q: params[:q]).call
    end
    @discussions       = @discussions_fetch.value

    if current_participant.present?
      @follows = current_participant.following.where(followable_type: 'Participant', followable_id: @participants.pluck(:id))
    end
  end
end
