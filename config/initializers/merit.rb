# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  # config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongoid
  # config.orm = :active_record

  # Add application observers to get notifications when reputation changes.
  # config.add_observer 'MyObserverClassName'

  # Define :user_model_name. This model will be used to grand badge if no
  # `:to` option is given. Default is 'User'.
  config.user_model_name = 'Participant'

  # Define :current_user_method. Similar to previous option. It will be used
  # to retrieve :user_model_name object if no `:to` option is given. Default
  # is "current_#{user_model_name.downcase}".
  # config.current_user_method = 'current_user'
end

# Create application badges (uses https://github.com/norman/ambry)
# badge_id = 0
# [{
#   id: (badge_id = badge_id+1),
#   name: 'just-registered'
# }, {
#   id: (badge_id = badge_id+1),
#   name: 'best-unicorn',
#   custom_fields: { category: 'fantasy' }
# }].each do |attrs|
#   Merit::Badge.create! attrs
# end
Merit::Badge.create!(
    id: 1,
    name: "gold-challenge-end",
    description: "Gold Medal winner for a challenge",
)
Merit::Badge.create!(
    id: 2,
    name: "silver-challenge-end",
    description: "Silver Medal winner for a challenge",
    )
Merit::Badge.create!(
    id: 3,
    name: "bronze-challenge-end",
    description: "Bronze Medal winner for a challenge",
    )
Merit::Badge.create!(
    id: 4,
    name: "gold-challenge-during",
    description: "Gold Medal during a challenge",
    )
Merit::Badge.create!(
    id: 5,
    name: "silver-challenge-during",
    description: "Silver Medal during a challenge",
    )
Merit::Badge.create!(
    id: 6,
    name: "bronze-challenge-during",
    description: "Bronze Medal during a challenge",
    )
Merit::Badge.create!(
    id: 7,
    name: "gold-submitter",
    description: "Has made more than 1000 successful submissions",
    )
Merit::Badge.create!(
    id: 8,
    name: "silver-submitter",
    description: "Has made more than 100 successful submissions",
    )
Merit::Badge.create!(
    id: 9,
    name: "bronze-submitter",
    description: "Has made more than 10 submissions",
    )
Merit::Badge.create!(
    id: 13,
    name: "Beginner",
    description: "Has made first submission",
    )
Merit::Badge.create!(
    id: 14,
    name: "Learner",
    description: "Has made first successful submission",
    )

Merit::Badge.create!(
    id: 15,
    name: "Trustable",
    description: "Has Filled his profile page",
    )


#Help Required from other team members
Merit::Badge.create!(
    id: 17,
    name: "Team Player",
    description: "For every 1 Team and first successful submission by the team",
    )

Merit::Badge.create!(
    id: 18,
    name: "Highest Streak",
    description: "For Maximum number of consecutive days",
    )

Merit::Badge.create!(
    id: 19,
    name: "Current Streak",
    description: "For current number of consecutive days",
    )

#After addition of user referral feature
Merit::Badge.create!(
    id: 16,
    name: "Well Wisher",
    description: "For every 1 user reffered",
    )

discourse_initial_id = ENV['DISCOURSE_INITIAL_ID'].to_i

response = Discourse::FetchBadgesMetaService.new.call

if response.success?
  response.value.each do |badge|
    Merit::Badge.create!(
        id: discourse_initial_id.to_i + badge['id'].to_i,
        name: badge['name'],
        description: badge['description'],
        )
  end
end

#After addition of a feature to track this
Merit::Badge.create!(
    id: 20,
    name: "Benefactor",
    description: "For every 1 challenge submission he has open-sourced",
    )

#Discourse
Merit::Badge.create!(
    id: 21,
    name: "Curious",
    description: "Has made first post on discourse",
    )
Merit::Badge.create!(
    id: 22,
    name: "Explainer",
    description: "Has 10 posts/comments on Dicourse",
    )

Merit::Badge.create!(
    id: 23,
    name: "Better Explainer",
    description: "For every 100 posts/comments on Dicourse",
    )

Merit::Badge.create!(
    id: 24,
    name: "Illumninated",
    description: "For every 1000 posts/comments on Dicourse",
    )

Merit::Badge.create!(
    id: 25,
    name: "Refiner",
    description: "For every 100 upvotes/downvotes on Dicourse",
    )

Merit::Badge.create!(
    id: 26,
    name: "Gold-Discussions",
    description: "For every Discussion with 10 votes",
    )

Merit::Badge.create!(
    id: 27,
    name: "Silver-Discussions",
    description: "For every Discussion with 5 votes",
    )
Merit::Badge.create!(
    id: 28,
    name: "Bronze-Discussions",
    description: "For every Discussion with 1 vote",
    )
