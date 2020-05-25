class GdprExportsController < ApplicationController
  before_action :authenticate_participant!
  respond_to :js

  def create
    GdprMailer.export_email(current_participant).deliver_later
  end
end
