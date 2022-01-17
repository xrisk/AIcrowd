class SearchesController < ApplicationController
  DEFAULT_LIMIT = 6.freeze

  def show
    records = PgSearch.multisearch(params[:q]).limit(100)
    challenge_ids = records.where(searchable_type: "Challenge").pluck(:searchable_id)
    participant_ids =  records.where(searchable_type: "Participant").pluck(:searchable_id)

    @challenges = Challenge.where(id: challenge_ids)
    @participants = Participant.where(id: participant_ids)
    @challenges = @challenges.limit(DEFAULT_LIMIT) unless params[:show_all_challenges]
    @participants = Participant.where(id: participant_ids).limit(DEFAULT_LIMIT) unless params[:show_all_participants]
    @discussions_fetch = Rails.cache.fetch("discourse-search-discussions/#{params[:q]}", expires_in: 5.minutes) do
      Discourse::FetchSearchResultsService.new(q: params[:q]).call
    end
    @discussions = @discussions_fetch.value

    if current_participant.present?
      @follows = current_participant.following.where(followable_type: 'Participant', followable_id: @participants.pluck(:id))
    end
  end

  def autocomplete
    @records = PgSearch.multisearch(params[:query]).limit(10).pluck(:content)
    data = []
    @records.map{|content| data << {name: content}}

    render json: data
  end
end
