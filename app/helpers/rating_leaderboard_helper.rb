module RatingLeaderboardHelper
  def tier_calculate(ranking)
    percentile = (1 - ((ranking - 1).to_f/@count))*100
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
end
