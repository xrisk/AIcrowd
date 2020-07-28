namespace :leaderboards do
  desc 'Move submitter_id from OldParticipant submitter_type to old_participant_id'
  task migrate_old_partcipants_submitter_id_to_old_participant_id: :environment do
    BaseLeaderboard.where(submitter_type: 'OldParticipant').find_each do |leaderboard|
      leaderboard.update!(old_participant_id: leaderboard.submitter_id, submitter_type: nil, submitter_id: nil)

      puts "##{leaderboard.id} Leaderboard - finished migration of OldParticipant submitter_id to old_participant_id"
    end
  end
end
