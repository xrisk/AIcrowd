# Be sure to restart your server when you modify this file.
#
# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit/point_rules.rb+. They are given on
# actions-triggered, either to the action user or to the method (or array of
# methods) defined in the +:to+ option.
#
# 'score' method may accept a block which evaluates to boolean
# (recieves the object as parameter)

module Merit
  class PointRules
    include Merit::PointRulesMethods

    def initialize
      # score 10, :on => 'users#create' do |user|
      #   user.bio.present?
      # end
      #
      # score 15, :on => 'reviews#create', :to => [:reviewer, :reviewed]
      #
      # score 20, :on => [
      #   'comments#create',
      #   'photos#create'
      # ]
      #
      # score -10, :on => 'comments#destroy'


      score 1, :on => 'votes#create', category: 'Liked Challenge' do |vote|
        vote.votable_type == "Challenge"
      end

      score -1, :on => 'votes#destroy', category: 'Liked Challenge' do |vote|
        vote.votable_type == "Challenge"
      end

      # Followed n number of challenges

      score 1, :on => 'follows#create', category: 'Followed Challenge' do |follow|
        follow.followable_type == "Challenge"
      end

      score -1, :on => 'follows#destroy', category: 'Followed Challenge' do |follow|
        follow.followable_type == "Challenge"
      end

      # Participated in n number of challenges

      score 1, :on => ['challenge_participants#create'], category: 'Participated Challenge'

      # Badges for number of submissions

      score 1, :on => 'submissions#create', category: 'Made Submission'

      # Badges for number of successful submissions

      score 1, :on => 'submissions#create', category: 'Made Successful Submission' do |submission|
        submission.grading_status_cd == 'graded'
      end


      # Badges for winning a challenge
      # Liked n number of practice problems

      score 1, :on => 'votes#create', category: 'Liked Practice Challenge' do |vote|
        vote.votable_type == "Challenge" && vote.votable.practice_flag == true
      end

      score -1, :on => 'votes#destroy', category: 'Liked Practice Challenge' do |vote|
        vote.votable_type == "Challenge" && vote.votable.practice_flag == true
      end

      # Shared n number of practice problems
      # Followed n number of practice problems

      score 1, :on => 'follows#create', category: 'Followed Practice Challenge' do |follow|
        follow.followable_type == "Challenge" && follow.followable.practice_flag == true
      end

      score -1, :on => 'follows#destroy', category: 'Followed Practice Challenge' do |follow|
        follow.followable_type == "Challenge" && follow.followable.practice_flag == true
      end


      # Participate in n number of practice problems

      score 1, :on => ['challenge_participants#create', 'challenge_participants#update'], category: 'Participated Practice Challenge' do |challenge_participant|
        challenge_participant.challenge.practice_flag == true
      end

      # N number of successful submissions in practice problems

      score 1, :on => 'submissions#create', category: 'Made Successful Practice Submission' do |submission|
        submission.challenge.practice_flag == true
      end

      # Badges for consecutive days submissions

      # score 1, :on => 'submissions#create', category: 'submitted-40-submissions' do |submission|
      #   submission.participant.submissions.count == 40
      # end

      # score 1, :on => 'submissions#create', category: 'submitted-80-submissions' do |submission|
      #   submission.participant.submissions.count == 80
      # end

      # score 1, :on => 'submissions#create', category: 'submitted-120-submissions' do |submission|
      #   submission.participant.submissions.count == 120
      # end

      # Badges for rank improvement
      # Badges for score improvement
      # Actively participated in one challenge, made 2 submissions and liked 2 challenges.
      # Badges for inviting users


      # Notebook Related Badges

      # Create Notebook Badges

      score 1, :on => 'posts#create', category: 'Created Notebook'

      score -1, :on => 'posts#destroy', category: 'Created Notebook'

      score 1, :on => 'posts#update', category: 'Won Blitz Community Explainer', to: :participant do |post|
        post.blitz_community_winner
      end

      score 1, :on => 'posts#update', category: 'Won Challenge Community Explainer', to: :participant do |post|
        post.community_explainer_winner
      end

      # Notebook shared n times

      # Participant liked notebooks n number of times

      score 1, :on => ['votes#create', 'votes#white_vote_create'], category: 'Liked Notebook' do |vote|
        vote.votable_type == "Post"
      end

      score -1, :on => ['votes#destroy', 'votes#white_vote_destroy'], category: 'Liked Notebook' do |vote|
        vote.votable_type == "Post"
      end

      # Participant Notebooks were liked n number of times

      score 1, :on => ['votes#create', 'votes#white_vote_create'], category: 'Notebook Was Liked', to: :participant do |vote|
        vote.votable_type == "Post"
      end

      score -1, :on => ['votes#destroy', 'votes#white_vote_destroy'], category: 'Notebook Was Liked', to: :participant do |vote|
        vote.votable_type == "Post"
      end


      # Participant commented on a notebook n number of times
      score 1, :on => ['commontator/comments#create'], category: 'Commented On Notebook', model_name: 'CommontatorThread' do |comment|
        comment.commontable_type == "Post" && CommontatorComment.where(thread_id: comment.id).count == 5
      end

      score 1, :on => ['commontator/comments#create'], category: 'Commented On Notebook', model_name: 'CommontatorThread' do |comment|
        comment.commontable_type == "Post" && CommontatorComment.where(thread_id: comment.id).count == 15
      end

      score 1, :on => ['commontator/comments#create'], category: 'Commented On Notebook', model_name: 'CommontatorThread' do |comment|
        comment.commontable_type == "Post" && CommontatorComment.where(thread_id: comment.id).count == 35
      end

      # Participant notebooks received n number of comments

      # score 1, :on => ['commontator/comments#create'], category: 'Commented On Notebook', model_name: 'CommontatorThread do |comment|
      #   if comment.commontable_type == "Post"
      #     Post.where()
      #   end
      # end

      # score 1, :on => ['commontator/comments#create'], category: 'Commented On Notebook', model_name: 'CommontatorThread do |comment|
      #   comment.commontable_type == "Post" && CommontatorComment.where(thread_id: comment.id).count == 15
      # end

      # score 1, :on => ['commontator/comments#create'], category: 'Commented On Notebook', model_name: 'CommontatorThread do |comment|
      #   comment.commontable_type == "Post" && CommontatorComment.where(thread_id: comment.id).count == 35
      # end

      # Subscribed n times
      #
      score 1, :on => 'post_bookmarks#create', category: 'Bookmarked Notebook'

      score -1, :on => 'post_bookmarks#destroy', category: 'Bookmarked Notebook'

      # N subscribers

      score 1, :on => 'post_bookmarks#create', category: 'Notebook Was Bookmarked', to: :participant

      score -1, :on => 'post_bookmarks#destroy', category: 'Notebook Was Bookmarked', to: :participant

      # Download notebooks
      # Created one notebook, like 3 notebooks, shared 2 notebooks
      # Created n number of blitz notebooks


      # Created first notebook
      score 1, :on => 'posts#create', category: 'Created First Notebook' do |post|
        participant.points(category: 'Created First Notebook') == 0
      end

      # # Shared first notebook
      # # Notebook was shared first time

      # # Liked 1 notebook
      score 1, :on => 'votes#create', category: 'Liked First Notebook' do |vote|
        vote.votable_type == "Post" && participant.points(category: 'Liked First Notebook') == 0
      end

      # # Notebook got first like

      score 1, :on => 'votes#create', category: 'Notebook got first like', to: :participant do |vote|
        vote.votable_type == "Post" && participant.points(category: 'Notebook got first like') == 0
      end

      # # Commented on 1 notebook
      # # Notebook got 1 comment
      # # You subscribed to your 1st notebook
      # # Your notebook got 1st subscriber
      # # You downloaded your 1st notebook
      # # Your notebook got its 1st download
      # # Listing all the first time badges

      # # Sign Up
      # score 1, :on => 'participants/registrations#create', category: 'participant-signed-up' do
      # end

      # Complete Bio/Profile
      score 1, :on => 'participants#update', category: 'Completed Bio-Profile' do |participant|
        participant.bio.present? && participant.points(category: 'Completed Bio-Profile') == 0
      end

      # Fill up details on country
      score 1, :on => 'participants#update', category: 'Completed Country' do |participant|
        participant.country_cd.present? && participant.points(category: 'Completed Country') == 0
      end

      # Filling up details on portfolio/links
      score 1, :on => 'participants#update', category: 'Completed Portfolio/Links' do |participant|
        participant.website.present? &&
        participant.github.present? &&
        participant.linkedin.present? &&
        participant.twitter.present? &&
        participant.bio.present? &&
        participant.points(category: 'Completed Portfolio/Links') == 0
      end

      # Followed their first Aicrew member
      score 1, :on => 'follows#create', category: 'Followed First Member' do |follow|
        follow.followable_type == "Participant" && participant.points(category: 'Followed First Member') == 0
      end


      score 1, :on => 'follows#create', category: 'Got First Follower', to: :followable do |follow|
        follow.followable_type == "Participant" && participant.points(category: 'Got First Follower') == 0
      end

      # Liked a blogpost
      score 1, :on => 'votes#create', category: 'Liked First Blog' do |vote|
        vote.votable.is_a?(Blog) && participant.points(category: 'Liked First Blog') == 0
      end
    end
  end
end