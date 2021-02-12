class PopulateChallengeProperty < ActiveRecord::Migration[5.2]
  def change
    Challenge.all.each do |challenge|
      ChallengeProperty.create!(challenge_id: challenge.id, page_views: challenge.page_views)
    end
  end
end
