class WinnersController < ApplicationController
  include Concerns::ChallengeMasthead
  challenge_masthead_actions = [:index]

  include Concerns::DatasetFiles

  before_action :authenticate_participant!

  def index; end

  private

  def challenge_masthead_actions
    [:index]
  end
end
