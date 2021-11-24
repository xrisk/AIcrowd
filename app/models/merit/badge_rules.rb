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
      ### CHALLENGE BADGES

      # Shared challenge

      # Participated in n number of challenges

      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'Participated Challenge', level: 1 do |challenge_participant|
        challenge_participant.participant.challenge_participants.count >= 5
      end

      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'Participated Challenge', level: 2 do |challenge_participant|
        challenge_participant.participant.challenge_participants.count >= 10
      end

      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'Participated Challenge', level: 3 do |challenge_participant|
        challenge_participant.participant.challenge_participants.count >= 20
      end

      # Badges for number of submissions

      grant_on 'submissions#create', badge: 'Made Submission', level: 1 do |submission|
        submission.participant.submissions.count >= 40
      end

      grant_on 'submissions#create', badge: 'Made Submission', level: 2 do |submission|
        submission.participant.submissions.count >= 80
      end

      grant_on 'submissions#create', badge: 'Made Submission', level: 3 do |submission|
        submission.participant.submissions.count >= 120
      end

      # Finished in top 20 percentile
      # Finished in top 10 percentile
      # Finished in top 5 percentile
      # Shared Practice Problem

      # Participated In Practice Challenge

      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'Participated In Practice Challenge', level: 1 do |challenge_participant|
        challenge_ids = challenge_participant.participant.challenge_participants.pluck(:challenge_id)
        Challenge.where(id: challenge_ids, practice_flag: true).count >= 10
      end

      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'Participated In Practice Challenge', level: 2 do |challenge_participant|
        challenge_ids = challenge_participant.participant.challenge_participants.pluck(:challenge_id)
        Challenge.where(id: challenge_ids, practice_flag: true).count >= 20
      end

      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'Participated In Practice Challenge', level: 3 do |challenge_participant|
        challenge_ids = challenge_participant.participant.challenge_participants.pluck(:challenge_id)
        Challenge.where(id: challenge_ids, practice_flag: true).count >= 30
      end


      # Submission Streak
      grant_on 'submissions#create', badge: 'Submission Streak', level: 1 do |submission|
        submission.participant_streak_days >= 3
      end

      grant_on 'submissions#create', badge: 'Submission Streak', level: 1 do |submission|
        submission.participant_streak_days >= 7
      end

      grant_on 'submissions#create', badge: 'Submission Streak', level: 1 do |submission|
        submission.participant_streak_days >= 30
      end

      # Leaderboard Ninja
      # Improved Score
      # Invited User
      grant_on 'team_invitations/acceptances#create', badge: 'Invited User', model_name: "Invitation", level: 1 do |invitation|
        TeamInvitation.where(invitor_id: invitation.invitor_id, status: 'accepted').count >= 1
      end

      grant_on 'team_invitations/acceptances#create', badge: 'Invited User', model_name: "Invitation", level: 1 do |invitation|
        TeamInvitation.where(invitor_id: invitation.invitor_id, status: 'accepted') >= 5
      end

      grant_on 'team_invitations/acceptances#create', badge: 'Invited User', model_name: "Invitation", level: 1 do |invitation|
        TeamInvitation.where(invitor_id: invitation.invitor_id, status: 'accepted') >= 15
      end



      ### NOTEBOOK BADGES

      # Create Notebook Badges
      grant_on 'posts#create', badge: 'Created Notebook', level: 1 do |post|
        post.participant.posts.count >= 3
      end

      grant_on 'posts#create', badge: 'Created Notebook', level: 2 do |post|
        post.participant.posts.count >= 10
      end

      grant_on 'posts#create', badge: 'Created Notebook', level: 3 do |post|
        post.participant.posts.count >= 25
      end

      # Won Blitz Community Explainer
      grant_on 'posts#update', badge: 'Won Blitz Community Explainer', level: 1, to: :participant do |post|
        post.blitz_community_winner
      end

      # Won Challenge Community Explainer
      grant_on 'posts#update', badge: 'Won Challenge Community Explainer', level: 1, to: :participant do |post|
        post.community_explainer_winner
      end

      # Shared Notebook
      grant_on 'badges#shared_notebook', badge: 'Shared Notebook', model_name: 'Participant', level: 1 do |participant|
        participant.points(category: 'Shared Notebook') >= 10
      end

      grant_on 'badges#shared_notebook', badge: 'Shared Notebook', model_name: 'Participant', level: 2 do |participant|
        participant.points(category: 'Shared Notebook') >= 25
      end

      grant_on 'badges#shared_notebook', badge: 'Shared Notebook', model_name: 'Participant', level: 3 do |participant|
        participant.points(category: 'Shared Notebook') >= 40
      end

      # Notebook Was Shared
      grant_on 'badges#notebook_was_shared', badge: 'Notebook Was Shared', model_name: 'Post', to: :participant, level: 1 do |post|
        post.participant.points(category: 'Notebook Was Shared') >= 3
      end

      grant_on 'badges#notebook_was_shared', badge: 'Notebook Was Shared', model_name: 'Post', to: :participant, level: 2 do |post|
        post.participant.points(category: 'Notebook Was Shared') >= 15
      end

      grant_on 'badges#notebook_was_shared', badge: 'Notebook Was Shared', model_name: 'Post', to: :participant, level: 3 do |post|
        post.participant.points(category: 'Notebook Was Shared') >= 30
      end

      # Notebook Was Liked
      grant_on ['votes#create', 'votes#white_vote_create'], badge: 'Notebook Was Liked', level: 1, to: :participant do |vote|
        vote.votable.is_a?(Post) && vote.votable.votes.count >= 5
      end

      grant_on ['votes#create', 'votes#white_vote_create'], badge: 'Notebook Was Liked', level: 2, to: :participant do |vote|
        vote.votable.is_a?(Post) && vote.votable.votes.count >= 20
      end

      grant_on ['votes#create', 'votes#white_vote_create'], badge: 'Notebook Was Liked', level: 3, to: :participant do |vote|
        vote.votable.is_a?(Post) && vote.votable.votes.count >= 35
      end

      # Commented On Notebook
      grant_on ['commontator/comments#create'], badge: 'Commented On Notebook', model_name: 'CommontatorThread', level: 1 do |comment|
        comment.commontable_type == "Post" && CommontatorComment.where(thread_id: comment.id).count >= 5
      end

      grant_on ['commontator/comments#create'], badge: 'Commented On Notebook', model_name: 'CommontatorThread', level: 2 do |comment|
        comment.commontable_type == "Post" && CommontatorComment.where(thread_id: comment.id).count >= 15
      end

      # Notebook Received Comment
      grant_on ['commontator/comments#create'], badge: 'Notebook Received Comment', model_name: 'CommontatorThread', to: :post_user, level: 1 do |comment|
        return false if comment.commontable_type == "Post"
        post_ids = comment.post_user.posts.pluck(:participant_id)
        thread_ids = CommontatorThread.where(commontable_type: 'Post', commontable_id: post_ids).pluck(:id)
        CommontatorComment.where(thread_id: thread_ids).count >= 3
      end

      grant_on ['commontator/comments#create'], badge: 'Notebook Received Comment', model_name: 'CommontatorThread', to: :post_user, level: 2 do |comment|
        return false if comment.commontable_type == "Post"
        post_ids = comment.post_user.posts.pluck(:participant_id)
        thread_ids = CommontatorThread.where(commontable_type: 'Post', commontable_id: post_ids).pluck(:id)
        CommontatorComment.where(thread_id: thread_ids).count >= 15
      end

      grant_on ['commontator/comments#create'], badge: 'Notebook Received Comment', model_name: 'CommontatorThread', to: :post_user, level: 3 do |comment|
        return false if comment.commontable_type == "Post"
        post_ids = comment.post_user.posts.pluck(:participant_id)
        thread_ids = CommontatorThread.where(commontable_type: 'Post', commontable_id: post_ids).pluck(:id)
        CommontatorComment.where(thread_id: thread_ids).count >= 30
      end

      # Bookmarked Notebook
      grant_on 'post_bookmarks#create', badge: 'Bookmarked Notebook', level: 1, model_name: 'Post' do |post|
        post.post_bookmarks.count >= 5
      end

      grant_on 'post_bookmarks#create', badge: 'Bookmarked Notebook', level: 2, model_name: 'Post' do |post|
        post.post_bookmarks.count >= 15
      end

      # Notebook Received Bookmark
      grant_on 'post_bookmarks#create', badge: 'Notebook Received Bookmark', level: 1, model_name: 'Post', to: :participant do |post|
        post.post_bookmarks.count >= 3
      end

      grant_on 'post_bookmarks#create', badge: 'Notebook Received Bookmark', level: 2, model_name: 'Post', to: :participant do |post|
        post.post_bookmarks.count >= 15
      end

      grant_on 'post_bookmarks#create', badge: 'Notebook Received Bookmark', level: 3, model_name: 'Post', to: :participant do |post|
        post.post_bookmarks.count >= 30
      end

      # Executed Notebook
      # Notebook Was Executed
      grant_on 'badges#executed_notebook', badge: 'Notebook Was Executed', model_name: 'Post', to: :participant, level: 1 do |post|
        post.participant.points(category:'Notebook Was Executed') >= 5
      end

      grant_on 'badges#executed_notebook', badge: 'Notebook Was Executed', model_name: 'Post', to: :participant, level: 2 do |post|
        post.participant.points(category: 'Notebook Was Executed') >= 15
      end

      grant_on 'badges#executed_notebook', badge: 'Notebook Was Executed', model_name: 'Post', to: :participant, level: 3 do |post|
        post.participant.points(category: 'Notebook Was Executed') >= 35
      end

      # Created one notebook, like 3 notebooks, shared 2 notebooks
      # Created Blitz Notebook


      # INDUCTION BADGES

      # Sign Up

      grant_on 'participants/registrations#create', badge: 'Sign Up', level: 1 do
      end


      # Created first notebook
      grant_on 'posts#create', badge: 'Created First Notebook', level: 4 do |post|
        post.participant.posts.count >= 1
      end

      # Liked 1 notebook
      grant_on 'votes#create', badge: 'Liked First Notebook', level: 4, to: :participant do |vote|
        vote.participant.votes.where(votable_type: "Post").count >= 1
      end

      # Notebook got first like

      grant_on 'votes#create', badge: 'Notebook Received Like', level: 4 do |vote|
        vote.participant.votes.where(votable_type: "Post").count >= 1
      end

      # Complete Bio/Profile
      grant_on 'participants#update', badge: 'Completed Profile', level: 1 do |participant|
        participant.bio.present?
      end

      # Fill up details on country
      grant_on 'participants#update', badge: 'Completed Profile', level: 2 do |participant|
        participant.country_cd.present?
      end

      # Filling up details on portfolio/links
      grant_on 'participants#update', badge: 'Completed Profile', level: 3 do |participant|
        participant.website.present? && participant.github.present? && participant.linkedin.present? && participant.twitter.present? && participant.bio.present?
      end

      # Followed their first Aicrew member
      grant_on 'follows#create', badge: 'Followed First Member', level: 4 do |follow|
        follow.following.where(followable_type: "Participant").count >= 1
      end

      # Got First Follower
      grant_on 'follows#create', badge: 'Got First Follower', level: 4, to: :followable do |follow|
        follow.where(followable_id: follow.followable_id, followable_type: "Participant").count >= 1
      end

      # Liked a blogpost
      grant_on 'votes#create', badge: 'Liked First Blog', level: 4 do |vote|
        vote.votable.is_a?(Blog) && vote.participant.votes.where(votable_type: "Blog").count >= 1
      end

      # Logged First Feedback
      grant_on 'feedbacks#create', badge: 'Logged First Feedback', level: 4 do |feedback|
        Feedback.where(participant_id: feedback.participant_id).count >= 1
      end

      # Attended First Townhall/Workshop

      # Made their first team
      grant_on 'challenges/teams#create', badge: 'Created First Team', level: 4 do |team|
        TeamParticipant.where(team_id: team.id).count  >= 1
      end

      # Liked First Challenge
      grant_on 'votes#create', badge: 'Liked First Challenge', level: 4 do |vote|
        vote.participant.votes.where(votable_type: "Challenge").count >= 1
      end

      # Shared First Challenge

      # Followed First Challenge
      grant_on 'follows#create', badge: 'Followed Challenge', level: 4 do |follow|
        Follow.where(participant_id: follow.participant_id, followable_type: "Challenge").count >= 5
      end

      # Accepted Rules

      # Participated In First Challenge
      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'Participated In First Challenge', level: 4 do |challenge_participant|
        challenge_participant.participant.challenge_participants.count >= 1
      end

      # First Submission
      grant_on 'submissions#create', badge: 'First Submission', level: 4 do |submission|
        submission.participant.submissions.count >= 1
      end

      # First Submission With Baseline

      # First Successful Submission
      # Check this
      grant_on 'submissions#create', badge: 'First Successful Submission', level: 4 do |submission|
        submission.participant.submissions.where(grading_status_cd: 'graded').count >= 1
      end

      # Liked First Practice Problem
      grant_on 'votes#create', badge: 'Liked First Practice Problem', level: 4 do |vote|
        challenge_ids = vote.participant.votes.where(votable_type: "Challenge").pluck(:votable_id)
        Challenge.where(id: challenge_ids, practice_flag: true).count >= 1
      end

      # Shared First Practice Problem

      # Followed First Practice Problem
       grant_on 'follows#create', badge: 'Followed Practice Challenge', level: 4 do |follow|
        followable_ids = Follow.where(participant_id: follow.participant_id, followable_type: "Challenge").pluck(:followable_id)
        Challenge.where(id: followable_ids, practice_flag: true).count >= 1
      end

      # Participated In First Practice Problem
      grant_on ['challenge_participants#create', 'challenge_participants#update'], badge: 'Participated In First Practice Problem', level: 4 do |challenge_participant|
        challenge_participant.participant.challenge_participants.count >= 1
      end

      # Shared First Notebook
      # Notebook Was Shared First Time

      # Commented on Notebook
      grant_on ['commontator/comments#create'], badge: 'Commented on Notebook', model_name: 'CommontatorThread', level: 4 do |comment|
        comment.commontable_type == "Post" && CommontatorComment.where(thread_id: comment.id).count >= 1
      end

      # Notebook Received First Comment
      grant_on ['commontator/comments#create'], badge: 'Notebook Received First Comment', model_name: 'CommontatorThread', to: :post_user, level: 4 do |comment|
        comment.commontable_type == "Post"
      end

      # Bookmarked First Notebook
      grant_on 'post_bookmarks#create', badge: 'Bookmarked First Notebook', level: 4, model_name: 'Post' do |post|
        post.post_bookmarks.count >= 1
      end

      # Notebook Received Bookmark
      grant_on 'post_bookmarks#create', badge: 'Notebook Received First Bookmark', level: 4, model_name: 'Post', to: :participant do |post|
        post.post_bookmarks.count >= 1
      end

      # Downloaded First Notebook
      grant_on 'badges#downloaded_notebook', badge: 'Downloaded First Notebook', level: 4

      # Notebook Received Download"
      grant_on 'badges#notebook_received_download', badge: 'Notebook Received Download', model_name: 'Post', to: :participant, level: 4

    end
  end
end