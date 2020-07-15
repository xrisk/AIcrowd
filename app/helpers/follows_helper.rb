module FollowsHelper
  def follow_link_id(followable)
    "follow-link-#{followable.class.to_s.downcase}-#{followable.id}"
  end

  def follow_find_by_participant(participant, follows)
    follows&.find { |follow| follow.followable_id == participant.id && follow.followable_type == 'Participant' }
  end

  def follows_create_follow_path(followable, other_participant, active_tab = nil)
    url_helper_method_name = "#{followable.model_name.param_key}_follows_path"

    Rails.application.routes.url_helpers.public_send(url_helper_method_name, followable.id, target: params[:tab], other_participant: other_participant&.friendly_id, active_tab: active_tab)
  end

  def follows_destroy_follow_path(followable, follow_id, other_participant, active_tab = nil)
    url_helper_method_name = "#{followable.model_name.param_key}_follow_path"

    Rails.application.routes.url_helpers.public_send(url_helper_method_name, followable.id, follow_id, target: params[:tab], other_participant: other_participant&.friendly_id, active_tab: active_tab)
  end
end
