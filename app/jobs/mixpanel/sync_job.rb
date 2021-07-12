class Mixpanel::SyncJob < ApplicationJob
  queue_as :default

  def is_present_in_profile(key)
    @user[key].present?
  end

  def get_value_in_profile(key)
    case key
    when 'github', 'linkedin', 'twitter', 'website'
      return is_present_in_profile(key)
    else
      return @user[key]
    end
  end

  def perform(participant)
    if participant.present?
      @user = participant
      fields = {
        '$name': get_value_in_profile("name"),
        '$first_name': get_value_in_profile("first_name"),
        '$last_name': get_value_in_profile("last_name"),
        '$created': get_value_in_profile("created_at"),
        '$avatar': get_value_in_profile("image_url"),
        'Participant ID': get_value_in_profile("id"),
        'Github Filled': get_value_in_profile("github"),
        'LinkedIn Filled': get_value_in_profile("linkedin"),
        'Twitter Filled': get_value_in_profile("twitter"),
        'Website Filled': get_value_in_profile("website"),
        'Affiliation': get_value_in_profile("affiliation"),
        'Country': get_value_in_profile("country_cd"),
        'confirmed?': @user.confirmed_at.present?,
        'Email Subscription': get_value_in_profile("agreed_to_marketing"),
        'User Type': get_value_in_profile("user_type")
      }
      Tracker.people.set(@user.uuid, fields)
    end
  end

end
