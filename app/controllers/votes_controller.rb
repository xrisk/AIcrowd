class VotesController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_votable
  respond_to :js

  def create
    @vote             = @votable.votes.new
    @vote.participant = current_participant
    authorize @vote
    @vote.save
    @votable.update(vote_count: @votable.votes.count)
    Rails.logger.debug("updated: #{@votable.id}")
    render js: concept(Vote::Cell, @votable, current_participant: current_participant).call(:refresh)
  end

  def destroy # unvote
    Vote.destroy(params[:id])
    @votable.update(vote_count: @votable.votes.count)
    Rails.logger.debug "rendering destroy #{@votable}"
    render js: concept(Vote::Cell, @votable, current_participant: current_participant).call(:refresh)
  end

  private

  def set_votable
    params.each do |key, val|
      if key =~ /(.+)_id$/
        @votable = Regexp.last_match(1).classify.constantize.find(val)
        break
      end
    end
  end
end
