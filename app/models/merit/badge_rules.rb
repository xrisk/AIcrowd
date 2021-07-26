# Be sure to restart your server when you modify this file.
#
# +grant_on+ accepts:
# * Nothing (always grants)
# * A block which evaluates to boolean (recieves the object as parameter)
# * A block with a hash composed of methods to run on the target object with
#   expected values (+votes: 5+ for instance).
#
# +grant_on+ can have a +:to+ method name, which called over the target object
# should retrieve the object to badge (could be +:user+, +:self+, +:follower+,
# etc). If it's not defined merit will apply the badge to the user who
# triggered the action (:action_user by default). If it's :itself, it badges
# the created object (new user for instance).
#
# The :temporary option indicates that if the condition doesn't hold but the
# badge is granted, then it's removed. It's false by default (badges are kept
# forever).

module Merit
  class BadgeRules
    include Merit::BadgeRulesMethods

    def initialize
      # If it creates user, grant badge
      # Should be "current_user" after registration for badge to be granted.
      # Find badge by badge_id, badge_id takes presidence over badge
      # grant_on 'users#create', badge_id: 7, badge: 'just-registered', to: :itself

      # If it has 10 comments, grant commenter-10 badge
      # grant_on 'comments#create', badge: 'commenter', level: 10 do |comment|
      #   comment.user.comments.count == 10
      # end

      # If it has 5 votes, grant relevant-commenter badge
      # grant_on 'comments#vote', badge: 'relevant-commenter',
      #   to: :user do |comment|
      #
      #   comment.votes.count == 5
      # end

      # Changes his name by one wider than 4 chars (arbitrary ruby code case)
      # grant_on 'registrations#update', badge: 'autobiographer',
      #   temporary: true, model_name: 'User' do |user|
      #
      #   user.name.length > 4
      # end

      grant_on 'votes#create', badge: 'liked-5-challenge-badge', level: 1 do |vote|
        vote.participant.votes.where(votable_type: "Challenge").count == 5
      end

      grant_on 'votes#create', badge: 'liked-10-challenge-badge', level: 2 do |vote|
        vote.participant.votes.where(votable_type: "Challenge").count == 10
      end

      grant_on 'votes#create', badge: 'liked-20-challenge-badge', level: 3 do |vote|
        vote.participant.votes.where(votable_type: "Challenge").count == 20
      end

      grant_on 'follows#create', badge: 'followed-5-challenge', level: 1 do |follow|
        Follow.where(participant_id: follow.participant_id, followable_type: "Challenge").count == 5
      end

      grant_on 'follows#create', badge: 'followed-10-challenge', level: 2 do |follow|
        Follow.where(participant_id: follow.participant_id, followable_type: "Challenge").count == 10
      end

      grant_on 'follows#create', badge: 'followed-20-challenge', level: 3 do |follow|
        Follow.where(participant_id: follow.participant_id, followable_type: "Challenge").count == 20
      end

      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'participated-in-5-challenge', level: 1 do |challenge_participant|
        challenge_participant.participant.challenge_participants.count == 5
      end

      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'participated-in-10-challenge', level: 2 do |challenge_participant|
        challenge_participant.participant.challenge_participants.count == 10
      end

      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'participated-in-20-challenge', level: 3 do |challenge_participant|
        challenge_participant.participant.challenge_participants.count == 20
      end

      grant_on 'submissions#create', badge: 'submitted-40-submissions', level: 1 do |submission|
        submission.participant.submissions.count == 40
      end

      grant_on 'submissions#create', badge: 'submitted-80-submissions', level: 2 do |submission|
        submission.participant.submissions.count == 80
      end

      grant_on 'submissions#create', badge: 'submitted-120-submissions', level: 3 do |submission|
        submission.participant.submissions.count == 120
      end



    end
  end
end
