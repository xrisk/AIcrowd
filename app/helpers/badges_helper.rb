module BadgesHelper
  def active_badge(aicrowd_badges, participant = current_participant)
    points = participant.points(category: aicrowd_badges.first.name)

    aicrowd_badges.reorder(target: :desc).each do |badge|
      if points >= badge.target
        return badge
      end
    end
    return 0
  end

  def next_badge(aicrowd_badges, participant=current_participant)
    points = participant.points(category: aicrowd_badges.first.name)
    next_badge = aicrowd_badges.reorder(:target).last
    aicrowd_badges.reorder(:target).each do |badge|
      if points < badge.target
        next_badge = badge
        return next_badge
      end
    end
    next_badge
  end

  def all_badges_participant_data(participant=current_participant, sub_module='challenge')
    badge_names = AicrowdBadge.where('level is not NULL').where(sub_module: sub_module).pluck(:name).uniq
    badge_results = {}

    badge_names.each do |name|
      badges = AicrowdBadge.where(name: name).order(:target)
      current_points = participant.points(category: name)
      active_badge = active_badge(badges, participant)
      icon = active_badge.is_a?(AicrowdBadge) ? active_badge.image : ENV['BADGE_LOCKED_PATH']
      next_badge = next_badge(badges, participant)

      badge_results[name] =  {badges: badges, current_points: current_points, active_badge: active_badge, icon: icon, next_badge: next_badge}
    end

    return badge_results
  end


end