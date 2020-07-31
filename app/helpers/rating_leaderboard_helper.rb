module RatingLeaderboardHelper
  def tier_calculate(ranking)
    percentile = (1 - ((ranking - 1).to_f/ @count))* 100
    case percentile
    when 99..100
      tier = 1
    when 95..99
      tier = 2
    when 80..95
      tier = 3
    when 60..80
      tier = 4
    when 0..60
      tier = 5
    end
  end

  def rating_leaderboard_ranking_change(participant)
    if !(participant.ranking_change.to_i == 0)
      if participant.ranking_change > 0
        image_tag(
          'icon-change-up.svg',
          data:  { toggle: 'tooltip' },
          title: "+#{participant.ranking_change} change"
        )
      else
        image_tag('icon-change-down.svg',
                  data:  { toggle: 'tooltip' },
                  title: "-#{participant.ranking_change} change")
      end
    else
      image_tag(
        'icon-change-none.svg',
        data:  { toggle: 'tooltip' },
        title: 'No change'
      )
    end
  end
end
