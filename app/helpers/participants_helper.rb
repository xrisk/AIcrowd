module ParticipantsHelper
  def avatar_url(participant, size)
    if participant.avatar
      if size == 'profile'
        participant.avatar.url('thumbnail')
      else
        participant.avatar.url(size)
      end
    else
      'https://www.gravatar.com/avatar/?d=mm&s=200'
    end
  end
  # usage:  <%= image_tag avatar_url(user,'medium'), class: "img-responsive" %>
  #         <%= image_tag avatar_url(user,'thumbnail') %>

  def participant_link(participant)
    participant.present? ? participant_path(participant) : '#'
  end

  def rating_tier_class(participant)
    tier       = 1
    percentile = (1 - ((participant.ranking - 1).to_f/ Participant.rated_users_count))* 100
    case percentile
    when 99..100
      tier = 5
    when 95..99
      tier = 4
    when 80..95
      tier = 3
    when 60..80
      tier = 2
    end
    tier       = 0 if participant.admin?
    'user-rating-' + tier.to_s
  end

  def participant_avatar(participant, base_class = 'avatar')
    classes = base_class + ' ' + rating_tier_class(participant)
    image_tag participant.image_url, class: classes
  end

  def avatar
    params[:avatar].present? ? params[:avatar] : true
  end

  def location_id(participant)
    uniq_id      = SecureRandom.hex(2)
    random_class = uniq_id.to_s + '_' + participant&.id.to_s
    "participant_#{random_class}"
  end

  def followable_and_follow(follow, followers_or_following)
    follow_participant = followers_or_following == 'followers' ? follow.participant : follow.followable
    { followable: follow_participant, follow: current_participant.following_participant?(follow_participant.id) ? follow : nil }
  end

  def get_award_point_on_day(participant)
    return if participant.nil?

    participant.ml_activity_points.group_by_day(:created_at, format: '%Y-%m-%d').sum_points_by_day
  end
end
