Merit::BadgesSash.delete_all
Merit::Score::Point.delete_all
Merit::ActivityLog.delete_all

### CHALLENGE BADGES

# Shared challenge

# Participated in n number of challenges

participant_ids = ChallengeParticipant.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  challenge_participant_count = ChallengeParticipant.where(participant_id: p_id).count
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(challenge_participant_count, category: 'Participated Challenge')
  next if challenge_participant_count < 3

  bronze_badge_id = AicrowdBadge.where(name: 'Participated Challenge', level: 1).first.id
  silver_badge_id = AicrowdBadge.where(name: 'Participated Challenge', level: 2).first.id
  gold_badge_id = AicrowdBadge.where(name: 'Participated Challenge', level: 3).first.id

  if challenge_participant_count >= 21
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
    participant.add_badge(gold_badge_id)
  elsif challenge_participant_count >=9
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
  elsif challenge_participant_count >=3
    participant.add_badge(bronze_badge_id)
  end
end

# Badges for number of submissions

participant_ids = Submission.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant_submissions_count = Submission.where(participant_id: p_id).count
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(participant_submissions_count, category: 'Made Submission')
  next if participant_submissions_count < 10

  bronze_badge_id = AicrowdBadge.where(name: 'Made Submission', level: 1).first.id
  silver_badge_id = AicrowdBadge.where(name: 'Made Submission', level: 2).first.id
  gold_badge_id = AicrowdBadge.where(name: 'Made Submission', level: 3).first.id

  if participant_submissions_count >= 300
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
    participant.add_badge(gold_badge_id)
  elsif participant_submissions_count >=100
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
  elsif participant_submissions_count >=10
    participant.add_badge(bronze_badge_id)
  end
end

# Finished in top 20 percentile
# Finished in top 10 percentile
# Finished in top 5 percentile
# Shared Practice Problem

# Participated In Practice Challenge
participant_ids = ChallengeParticipant.pluck(:participant_id).uniq
practice_challenge_ids = Challenge.where(practice_flag: true).pluck(:id)
participant_ids.each do |p_id|
  challenge_participant_count = ChallengeParticipant.where(participant_id: p_id, challenge_id: practice_challenge_ids).count
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(challenge_participant_count, category: 'Participated Practice Challenge')
  next if challenge_participant_count < 10

  bronze_badge_id = AicrowdBadge.where(name: 'Participated In Practice Challenge', level: 1).first.id
  silver_badge_id = AicrowdBadge.where(name: 'Participated In Practice Challenge', level: 2).first.id
  gold_badge_id = AicrowdBadge.where(name: 'Participated In Practice Challenge', level: 3).first.id

  if challenge_participant_count >= 30
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
    participant.add_badge(gold_badge_id)
  elsif challenge_participant_count >=20
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
  elsif challenge_participant_count >=10
    participant.add_badge(bronze_badge_id)
  end
end

# Submission Streak <- This is not needed

# Leaderboard Ninja
# Improved Score
# Invited User
participant_ids = Submission.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  team_invitation_count = TeamInvitation.where(invitor_id: p_id, status: 'accepted').count
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(team_invitation_count, category: 'Invited User')
  next if team_invitation_count < 1

  bronze_badge_id = AicrowdBadge.where(name: 'Invited User', level: 1).first.id
  silver_badge_id = AicrowdBadge.where(name: 'Invited User', level: 2).first.id
  gold_badge_id = AicrowdBadge.where(name: 'Invited User', level: 3).first.id

  if team_invitation_count >= 15
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
    participant.add_badge(gold_badge_id)
  elsif team_invitation_count >= 5
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
  elsif team_invitation_count >= 1
    participant.add_badge(bronze_badge_id)
  end
end



### NOTEBOOK BADGES

# Create Notebook Badges
participant_ids = Post.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant_posts_count = Post.where(participant_id: p_id).count
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(participant_posts_count, category: 'Created Notebook')
  next if participant_posts_count < 3

  bronze_badge_id = AicrowdBadge.where(name: 'Created Notebook', level: 1).first.id
  silver_badge_id = AicrowdBadge.where(name: 'Created Notebook', level: 2).first.id
  gold_badge_id = AicrowdBadge.where(name: 'Created Notebook', level: 3).first.id

  if participant_posts_count >= 25
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
    participant.add_badge(gold_badge_id)
  elsif participant_posts_count >=10
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
  elsif participant_posts_count >=3
    participant.add_badge(bronze_badge_id)
  end
end

# Won Blitz Community Explainer
# Not Required

# Won Challenge Community Explainer
# Not Required

# Shared Notebook
# Notebook Was Shared

# Notebook Was Liked
participant_ids = Post.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  post_vote_count = Post.where(participant_id: p_id).map(&:votes).count
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(post_vote_count, category: 'Notebook Was Liked')
  next if post_vote_count < 10

  bronze_badge_id = AicrowdBadge.where(name: 'Notebook Was Liked', level: 1).first.id
  silver_badge_id = AicrowdBadge.where(name: 'Notebook Was Liked', level: 2).first.id
  gold_badge_id = AicrowdBadge.where(name: 'Notebook Was Liked', level: 3).first.id

  if post_vote_count >= 35
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
    participant.add_badge(gold_badge_id)
  elsif post_vote_count >=20
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
  elsif post_vote_count >=10
    participant.add_badge(bronze_badge_id)
  end
end

# Commented On Notebook
participant_ids = CommontatorComment.pluck(:creator_id).uniq
participant_ids.each do |p_id|
  comment_count = CommontatorComment.where(creator_id: p_id).count
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(comment_count, category: 'Commented On Post')
  next if comment_count < 10

  bronze_badge_id = AicrowdBadge.where(name: 'Commented On Post', level: 1).first.id
  silver_badge_id = AicrowdBadge.where(name: 'Commented On Post', level: 2).first.id

  if comment_count >= 25
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
  elsif comment_count >=10
    participant.add_badge(bronze_badge_id)
  end
end

# Notebook Received Comment
participant_ids = Post.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  post_ids = Post.where(participant_id: p_id).pluck(:id)
  post_comment_count = CommontatorThread.where(commontable_type: "Post", commontable_id: post_ids).count
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(post_comment_count, category: 'Notebook Received Comment')
  next if post_comment_count < 3

  bronze_badge_id = AicrowdBadge.where(name: 'Notebook Received Comment', level: 1).first.id
  silver_badge_id = AicrowdBadge.where(name: 'Notebook Received Comment', level: 2).first.id
  gold_badge_id = AicrowdBadge.where(name: 'Notebook Received Comment', level: 3).first.id

  if post_comment_count >= 30
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
    participant.add_badge(gold_badge_id)
  elsif post_comment_count >= 15
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
  elsif post_comment_count >= 3
    participant.add_badge(bronze_badge_id)
  end
end


# Bookmarked Notebook
participant_ids = PostBookmark.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  post_bookmark_count = PostBookmark.where(participant_id: p_id).count
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(post_bookmark_count, category: 'Bookmarked Notebook')
  next if post_bookmark_count < 5

  bronze_badge_id = AicrowdBadge.where(name: 'Bookmarked Notebook', level: 1).first.id
  silver_badge_id = AicrowdBadge.where(name: 'Bookmarked Notebook', level: 2).first.id

  if post_bookmark_count >= 15
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
  elsif post_bookmark_count >= 5
    participant.add_badge(bronze_badge_id)
  end
end

# Notebook Received Bookmark
participant_ids = PostBookmark.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  post_ids = Post.where(participant_id: p_id).pluck(:id)
  post_bookmark_count = PostBookmark.where(post_id: post_ids).count
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(post_bookmark_count, category: 'Notebook Received Bookmark')
  next if post_bookmark_count < 3

  bronze_badge_id = AicrowdBadge.where(name: 'Notebook Received Bookmark', level: 1).first.id
  silver_badge_id = AicrowdBadge.where(name: 'Notebook Received Bookmark', level: 2).first.id
  gold_badge_id = AicrowdBadge.where(name: 'Notebook Received Bookmark', level: 3).first.id

  if post_bookmark_count >= 30
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
    participant.add_badge(gold_badge_id)
  elsif post_bookmark_count >= 15
    participant.add_badge(bronze_badge_id)
    participant.add_badge(silver_badge_id)
  elsif post_bookmark_count >= 3
    participant.add_badge(bronze_badge_id)
  end
end

# Executed Notebook
# Notebook Was Executed
# Created one notebook, like 3 notebooks, shared 2 notebooks
# Created Blitz Notebook


# INDUCTION BADGES

# Sign Up
# Will add a condition on the badge rules


# Created first notebook
participant_ids = Post.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Created First Notebook')
  badge_id = AicrowdBadge.where(name: 'Created First Notebook', level: 4).first.id
  participant.add_badge(badge_id)
end

# Liked 1 notebook
participant_ids = Vote.where(votable_type: "Post").pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Liked First Notebook')
  badge_id = AicrowdBadge.where(name: 'Liked First Notebook', level: 4).first.id
  participant.add_badge(badge_id)
end

# Notebook got first like

post_ids = Vote.where(votable_type: "Post").pluck(:votable_id).uniq
participant_ids = Post.where(id: post_ids).pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Notebook Received Like')
  badge_id = AicrowdBadge.where(name: 'Notebook Received Like', level: 4).first.id
  participant.add_badge(badge_id)
end

# Complete Bio/Profile
participant_ids = Participant.where('bio is not NULL').pluck(:id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Completed Profile')
  badge_id = AicrowdBadge.where(name: 'Completed Profile', level: 1).first.id
  participant.add_badge(badge_id)
end

# Fill up details on country
participant_ids = Participant.where('country_cd is not NULL').pluck(:id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Completed Profile')
  badge_id = AicrowdBadge.where(name: 'Completed Profile', level: 2).first.id
  participant.add_badge(badge_id)
end

# Filling up details on portfolio/links
participant_ids = Participant.where('website is not NULL').where('github is not NULL').where('linkedin is not NULL').where('twitter is not NULL').pluck(:id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Completed Profile')
  badge_id = AicrowdBadge.where(name: 'Completed Profile', level: 3).first.id
  participant.add_badge(badge_id)
end

# Followed their first Aicrew member
participant_ids = Follow.where(followable_type: "Participant").pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Followed First Member')
  badge_id = AicrowdBadge.where(name: 'Followed First Member', level: 4).first.id
  participant.add_badge(badge_id)
end

# Got First Follower
participant_ids = Follow.where(followable_type: "Participant").pluck(:followable_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Got First Follower')
  badge_id = AicrowdBadge.where(name: 'Got First Follower', level: 4).first.id
  participant.add_badge(badge_id)
end

# Liked a blogpost
participant_ids = Vote.where(votable_type: "Blog").pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Liked First Blog')
  badge_id = AicrowdBadge.where(name: 'Liked First Blog', level: 4).first.id
  participant.add_badge(badge_id)
end

# Logged First Feedback
participant_ids = Feedback.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Logged First Feedback')
  badge_id = AicrowdBadge.where(name: 'Logged First Feedback', level: 4).first.id
  participant.add_badge(badge_id)
end

# Attended First Townhall/Workshop

# Made their first team
participant_ids = TeamParticipant.where(role: 'organizer').pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Created First Team')
  badge_id = AicrowdBadge.where(name: 'Created First Team', level: 4).first.id
  participant.add_badge(badge_id)
end

# Liked First Challenge
participant_ids = Vote.where(votable_type: "Challenge").pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Liked First Challenge')
  badge_id = AicrowdBadge.where(name: 'Liked First Challenge', level: 4).first.id
  participant.add_badge(badge_id)
end

# Shared First Challenge

# Followed First Challenge
participant_ids = Follow.where(followable_type: "Challenge").pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Followed First Challenge')
  badge_id = AicrowdBadge.where(name: 'Followed First Challenge', level: 4).first.id
  participant.add_badge(badge_id)
end

# Accepted Rules

# Participated In First Challenge
participant_ids = ChallengeParticipant.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Participated In First Challenge')
  badge_id = AicrowdBadge.where(name: 'Participated In First Challenge', level: 4).first.id
  participant.add_badge(badge_id)
end

# First Submission
participant_ids = Submission.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'First Submission')
  badge_id = AicrowdBadge.where(name: 'First Submission', level: 4).first.id
  participant.add_badge(badge_id)
end

# First Submission With Baseline

# First Successful Submission
participant_ids = Submission.where(grading_status_cd: 'graded').pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'First Successful Submission')
  badge_id = AicrowdBadge.where(name: 'First Successful Submission', level: 4).first.id
  participant.add_badge(badge_id)
end

# Liked First Practice Problem
practice_challenge_ids = Challenge.where(practice_flag: true).pluck(:id)
participant_ids = Vote.where(votable_type: "Challenge", votable_id: practice_challenge_ids).pluck(:participant_id)
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Liked First Practice Problem')
  badge_id = AicrowdBadge.where(name: 'Liked First Practice Problem', level: 4).first.id
  participant.add_badge(badge_id)
end


# Shared First Practice Problem

# Followed First Practice Problem
practice_challenge_ids = Challenge.where(practice_flag: true).pluck(:id)
participant_ids = Follow.where(followable_type: "Challenge", followable_id: practice_challenge_ids).pluck(:participant_id)
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Followed First Practice Problem')
  badge_id = AicrowdBadge.where(name: 'Followed First Practice Problem', level: 4).first.id
  participant.add_badge(badge_id)
end

# Participated In First Practice Problem
practice_challenge_ids = Challenge.where(practice_flag: true).pluck(:id)
participant_ids = ChallengeParticipant.where(challenge_id: practice_challenge_ids).pluck(:participant_id)
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Participated In First Practice Problem')
  badge_id = AicrowdBadge.where(name: 'Participated In First Practice Problem', level: 4).first.id
  participant.add_badge(badge_id)
end

# Shared First Notebook
# Notebook Was Shared First Time

# Commented on Notebook
participant_ids = CommontatorThread.pluck(:creator_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Commented on Notebook')
  badge_id = AicrowdBadge.where(name: 'Commented on Notebook', level: 4).first.id
  participant.add_badge(badge_id)
end

# Notebook Received First Comment
post_ids = CommontatorThread.where(commontable_type: "Post").pluck(:commontable_id)
participant_ids = Post.where(id: post_ids).pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Notebook Received First Comment')
  badge_id = AicrowdBadge.where(name: 'Notebook Received First Comment', level: 4).first.id
  participant.add_badge(badge_id)
end

# Bookmarked First Notebook
participant_ids = PostBookmark.pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Bookmarked First Notebook')
  badge_id = AicrowdBadge.where(name: 'Bookmarked First Notebook', level: 4).first.id
  participant.add_badge(badge_id)
end

# Notebook Received Bookmark
post_ids = PostBookmark.pluck(:post_id)
participant_ids = Post.where(id: post_ids).pluck(:participant_id).uniq
participant_ids.each do |p_id|
  participant = Participant.find(p_id)
  next if participant.blank?
  participant.add_points(1, category: 'Notebook Received Bookmark')
  badge_id = AicrowdBadge.where(name: 'Notebook Received Bookmark', level: 4).first.id
  participant.add_badge(badge_id)
end

# Downloaded First Notebook
# Notebook Received Download"