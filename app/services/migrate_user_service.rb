class MigrateUserService

  def initialize(crowdai_id:, aicrowd_id:)
    migrate_user(crowdai_id, aicrowd_id)
  end

  def migrate_user(old_id, new_id)
    submission_migration_mappings = MigrationMapping.where(crowdai_participant_id: old_id, source_type: 'Submission')

    submission_migration_mappings.each do |migration_mapping|
      submission = Submission.where(id: migration_mapping['source_id'])
      submission.update(participant_id: new_id)
    end

    cp_migration_mappings = MigrationMapping.where(crowdai_participant_id: old_id, source_type: 'ChallengeParticipant')
    cp_migration_mappings.each do |migration_mapping|
      cp = ChallengeParticipant.where(id: migration_mapping['source_id'])
      cp.update(participant_id: new_id)
    end

    MigrationMapping.create!(crowdai_participant_id: old_id, source_id: new_id, source_type: 'Participant')
  end

end