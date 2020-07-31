# frozen_string_literal: true

class Participants::RegistrationsController < Devise::RegistrationsController
  include Recaptcha
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.
  prepend_before_action :set_referred_by_id, only: [:create]

  private

  def check_captcha
    return if !Rails.env.production? || verify_recaptcha

    self.resource = resource_class.new sign_up_params
    resource.validate # Look for any other validation errors besides Recaptcha
    set_minimum_password_length
    respond_with_navigational(resource) { render :new }
  end

  def set_referred_by_id
    return if params[:referred_by_uuid].blank?

    # We need to add referred_by_id to allowed parameters white list
    devise_parameter_sanitizer.permit(:sign_up, keys: [:referred_by_id])

    referred_by_id = Participant.find_by(uuid: params[:referred_by_uuid])&.id

    params[:participant][:referred_by_id] = referred_by_id
  end
end
