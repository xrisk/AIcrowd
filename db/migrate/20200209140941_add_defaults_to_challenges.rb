class AddDefaultsToChallenges < ActiveRecord::Migration[5.2]
  def change
    change_column_default :challenges, :description, from: nil, to: "<h2> Placeholder Content : Please update this by going into Edit Challenge > Overview > Description </h2> "
    change_column_default :challenges, :description_markdown, from: nil, to: "## Placeholder Content : Please update this by going into Edit Challenge > Overview > Description "
    change_column_default :challenges, :submission_license, from: nil, to: "Please upload your submissions and include a detailed description of the methodology, techniques and insights leveraged with this submission. After the end of the challenge, these comments will be made public, and the submitted code and models will be freely available to other AIcrowd participants. All submitted content will be licensed under Creative Commons (CC)."
    change_column_default :challenges, :grader_identifier, from: nil, to: "AIcrowd_GRADER_POOL"
    change_column_default :challenge_rounds, :submission_limit, from: nil, to: 5
    change_column_default :challenge_rounds, :submission_limit_period_cd, from: nil, to: "day"
    change_column_default :challenge_rounds, :minimum_score, from: nil, to: 0
    change_column_default :challenge_rounds, :minimum_score_secondary, from: nil, to: 0
    change_column_default :challenge_rounds, :ranking_window, from: nil, to: 96
    change_column_default :challenge_rounds, :ranking_highlight, from: nil, to: 3
    change_column_default :challenge_rounds, :score_precision, from: nil, to: 3
    change_column_default :challenge_rounds, :score_secondary_precision, from: nil, to: 3
    change_column_default :challenge_rounds, :score_title, from: nil, to: "Score"
    change_column_default :challenge_rounds, :score_secondary_title, from: nil, to: "Secondary Score"
    change_column_default :challenge_rules, :terms, from: nil, to: "<h2> Placeholder Content : Please update this by going into Edit Challenge > Rules > Set Challenge Rules </h2> "
    change_column_default :challenge_rules, :terms_markdown, from: nil, to: "## Placeholder Content : Please update this by going into Edit Challenge > Rules > Set Challenge Rules "
  end
end
