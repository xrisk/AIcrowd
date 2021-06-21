# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ::ActionController::HttpAuthentication::Token::ControllerMethods
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized_or_login
  impersonates :participant, method: :current_participant, with: ->(id) { Participant.friendly.find(id) }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit
  after_action :track_action
  before_action :store_user_location!, if: :storable_location?
  before_action :modify_params_for_meta_challenges
  before_action :notifications
  before_action :check_for_redirection
  before_action :block_ip_addresses
  before_action :redirect_old_challenge_slugs
  helper_method :mobile?

  def track_action
    properties         = { request: request.filtered_parameters }
    properties[:flash] = flash.to_json unless flash.empty?
    ahoy.track "Processed #{controller_name}##{action_name}", properties
  end

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: 'Not authorized' } }
  end

  def append_info_to_payload(payload)
    super
    payload[:request_id] = request.uuid
    payload[:user_id]    = current_user.id if current_user
  end

  def notifications
    if current_user.present?
      @notifications = Rails.cache.fetch("participant_notifications_#{current_user.id}") do
        current_user&.notifications
      end
    end
  end

  attr_reader :is_api_request

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation, :remember_me,
               :agreed_to_terms_of_use_and_privacy,
               :agreed_to_marketing)
    end
  end

  def modify_params_for_meta_challenges
    if controller_name == "challenges"
      if params.has_key?('challenge_id')
        params[:meta_challenge_id] = params['challenge_id']
        params.delete('challenge_id')
      end
    end
    if params.has_key?('problem_id')
      if params.has_key?('challenge_id')
        if !params.has_key?('meta_challenge_id')
          params[:meta_challenge_id] = params[:challenge_id]
          params[:challenge_id] = params[:problem_id]
          params.delete('problem_id')
        end
      end
    end
  end

  def pundit_user
    current_participant
  end

  def current_user
    current_participant
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr? && params[:controller] != 'challenge_rules'
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource)
    if resource.name.length > 20
      flash[:alert] = "Maximum length for username is reduced to 20 characters, please change your username #{helpers.link_to '[here]', edit_participant_path(resource), target: '_blank'}"
    end

    unless current_participant.agreed_to_terms_of_use_and_privacy?
      flash[:notice] = 'We have changed the way we save email and notification preferences, please review them below'
      current_participant.update(agreed_to_terms_of_use_and_privacy: true)
      return participant_notifications_path(current_participant)
    end

    # Prioritise return path set by application logic
    if session.has_key?(:participant_return_to)
      return session['participant_return_to']
    end

    # Redirect based on available browsing history
    return stored_location_for(:user) || root_path
  end

  def not_authorized_or_login
    if current_participant
      not_authorized
    else
      request_login
    end
  end

  def request_login
    flash[:info] = 'Please log into AIcrowd to perform this action.'
    redirect_to new_participant_registration_path
  end

  def not_authorized
    flash[:error] = 'You are not authorised to access this page.'
    redirect_to root_path
  end

  def search_params
    params[:q]
  end

  def clear_search_index
    if params[:search_cancel]
      params.delete(:search_cancel)
      search_params&.each do |key, _param|
        search_params[key] = nil
      end
    end
  end

  # TODO: Investigate if we can get rid of this weird override of default settings
  def default_url_options
    if Rails.env.test?
      super
    else
      { host: ENV['DOMAIN_NAME'] || 'localhost:3000' }
    end
  end

  def set_user_by_token(mapping = nil)
    if is_api_request?
      authenticate_or_request_with_http_token do |token, options|
        participant = Participant.find_by(api_key: token)
        if participant.present?
          sign_in(:participant, participant)
        end
      end
    end
  end

  def is_api_request?
    params[:is_api_request].present? && params[:is_api_request]
  end

  def check_for_redirection
    url = request.path
    if request.get? && url.count('/') == 1 && Redirect.where(redirect_url: url, active: true).exists?
      destination_url = Redirect.where(redirect_url: url, active: true).first.destination_url
      redirect_to destination_url and return
    end
  end

  def block_ip_addresses
    if ENV['BLOCKED_IP_ADDRESS'].present? && params.has_key?('challenge_id')
      not_authorized if ENV['BLOCKED_IP_ADDRESS'].split(",").include?(request.remote_ip)
    end
  end

  def redirect_old_challenge_slugs
    split_url = request.path.split('/')
    query_params = request.original_url.split('?')[1]
    if request.get? && split_url[1] == "challenges" &&  split_url.size > 2 && split_url[2] != "new"
      challenge = Challenge.friendly.find(split_url[2])
      if challenge.present?
        if split_url[2].is_a?(Integer) || split_url[2] != challenge.slug
          split_url[2] = challenge.slug
          new_url = split_url.join('/')
          new_url = [new_url, query_params].join('?') if query_params.present?
          redirect_to new_url, status: 301
        end
      end
    end
  end

  def mobile? # has to be in here because it has access to "request"
    request.user_agent =~ /\b(Android|iPhone|iPad|Windows Phone|Opera Mobi|Kindle|BackBerry|PlayBook)\b/i
  end

end
