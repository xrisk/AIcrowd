class WinnersController < ApplicationController
  include Concerns::ChallengeMasthead
  challenge_masthead_actions [:index]

  before_action :authenticate_participant!

  def index; end
end
