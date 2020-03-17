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
    tier = 1
    percentile = (1 - ((participant.ranking - 1).to_f/participant.rated_users))*100
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
    if participant.admin?
      tier = 0
    end
    return "user-rating-" + tier.to_s
  end

  def participant_avatar(participant, base_class='avatar')
    classes = base_class + ' ' + rating_tier_class(participant)
    return image_tag participant.image_url, class: classes
  end
end
