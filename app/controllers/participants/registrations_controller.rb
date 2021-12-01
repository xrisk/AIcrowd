# frozen_string_literal: true

class Participants::RegistrationsController < Devise::RegistrationsController
  include Recaptcha
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.
  prepend_before_action :set_referred_by_id, only: [:create]
  prepend_before_action :set_first_name_and_last_name, only: [:create]
  after_action :registration_completion_callback, only: [:create]

  private

  def registration_completion_callback
    user = resource
    return if user.id.nil?

    Mixpanel::EventJob.perform_later(user, 'Registration Complete', {
      'Registration Method': 'Email',
    })
  end

  def check_captcha
    return if !Rails.env.production? || verify_recaptcha
    self.resource = resource_class.new sign_up_params
    resource.validate # Look for any other validation errors besides Recaptcha
    set_minimum_password_length
    respond_with_navigational(resource) { render :new }
  end

  def set_first_name_and_last_name
    return if params[:participant][:full_name].blank?
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])

    first_name, last_name = get_first_and_last_name(params[:participant][:full_name])

    params[:participant][:first_name] = first_name
    params[:participant][:last_name] = last_name
  end

  def set_referred_by_id
    return if params[:referred_by_uuid].blank?

    # We need to add referred_by_id to allowed parameters white list
    devise_parameter_sanitizer.permit(:sign_up, keys: [:referred_by_id])

    referred_by_id = Participant.find_by(uuid: params[:referred_by_uuid])&.id

    params[:participant][:referred_by_id] = referred_by_id
  end

  def get_first_and_last_name(full_name)
    name_array = full_name.split(' ')

    if name_array.count > 1
      last_name  = name_array.pop
      first_name = name_array.join(' ')
    else
      first_name = name_array.first
      last_name  = nil
    end

    return [ first_name, last_name ]
  end
end
