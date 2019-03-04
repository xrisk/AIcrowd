class ErrorsController < ApplicationController
  def show
    @code = params[:code]&.to_i || 500
    @message = t(@code, scope: 'http_error', default: @code.to_s)
    render layout: 'error'
  end
end
