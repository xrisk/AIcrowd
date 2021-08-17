class WinnersController < ApplicationController
  include Concerns::ChallengeMasthead
  challenge_masthead_actions [:index]

  def index; end
end
