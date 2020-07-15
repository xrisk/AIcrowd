class SearchesController < ApplicationController
  DEFAULT_LIMIT = 6.freeze

  def show
    @participants = Participant.where('name ILIKE ?', "%#{params[:q]}%").limit(DEFAULT_LIMIT)
    if current_participant.present?
      @follows = current_participant.following.where(followable_type: 'Participant', followable_id: @participants.pluck(:id))
    end

    @challenges = policy_scope(Challenge).where('challenge ILIKE ? OR description ILIKE ?', "%#{params[:q]}%", "%#{params[:q]}%").limit(DEFAULT_LIMIT)
  end
end
