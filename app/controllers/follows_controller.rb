class FollowsController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_followable
  before_action :set_participant, only: [:create, :destroy], if: :followable_is_participant?

  respond_to :js

  def create
    @follow             = @followable.follows.new
    @follow.participant = current_participant
    @follow.save!
    respond_to do |format|
      format.js { render :refresh }
    end
  end

  def destroy
    if !params[:challenge_id].present?
      if current_participant.following_participant?(params[:participant_id])
        current_participant.following.participant_type.where(followable_id: params[:participant_id]).first.destroy
      end
    else
      Follow.destroy(params[:id])
    end
    respond_to do |format|
      format.js { render :refresh }
    end
  end

  private

  def set_followable
    params.each do |key, val|
      if key =~ /(.+)_id$/
        @followable = Regexp.last_match(1).classify.constantize.find(val)
        break
      end
    end
  end

  def set_participant
    participant_id = params[:other_participant].present? ? params[:other_participant] : params[:participant_id]
    @participant   = Participant.friendly.find_by_friendly_id(participant_id.downcase)
  end

  def followable_is_participant?
    @followable.class.eql?(Participant)
  end
end
