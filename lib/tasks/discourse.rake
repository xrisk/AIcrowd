namespace :discourse do
  desc "Hide Discourse categories for hidden challenges"
  task hide_discourse_categories_for_hidden_challenges: :environment do
    Challenge.draft_or_private.find_each do |challenge|
      puts "##{challenge.id} #{challenge.challenge} | Discourse category update"
      Discourse::UpdateCategoryJob.perform_later(challenge.id)
    end
  end

  desc "Add challenges participants to custom Discourse groups"
  task add_challenge_participants_to_discourse_groups: :environment do
    Challenge.where('discourse_group_name IS NOT NULL').find_each do |challenge|
      puts "##{challenge.id} #{challenge.challenge} | Discourse group update"
      Discourse::AddUsersToGroupJob.perform_later(challenge.id, challenge.participants_and_organizers.map(&:id))
    end
  end
end
