class MigrateUserService

  def initialize(crowdai_id:, aicrowd_id:)
    @old_id = crowdai_id
    @new_id = aicrowd_id
  end

  def check_migrated
    MigrationMapping.where(crowdai_participant_id: @old_id, source_type: 'Participant').count.positive?
  end

  def migrate_user
    raise "User Already Migrated" if check_migrated
    ActiveRecord::Base.transaction do
      submission_migration_mappings = MigrationMapping.where(crowdai_participant_id: @old_id, source_type: 'Submission')

      submission_migration_mappings.each do |migration_mapping|
        submission = Submission.where(id: migration_mapping['source_id']).first
        submission&.update(participant_id: @new_id)
      end

      cp_migration_mappings = MigrationMapping.where(crowdai_participant_id: @old_id, source_type: 'ChallengeParticipant')
      cp_migration_mappings.each do |migration_mapping|
        cp = ChallengeParticipant.where(id: migration_mapping['source_id']).first
        cp&.update(participant_id: @new_id)
        cp.challenge.challenge_rounds.each do |challenge_round|
          CalculateLeaderboardJob.perform_later(challenge_round_id: challenge_round.id)
        end
      end

      pct_migration_mappings = MigrationMapping.where(crowdai_participant_id: @old_id, source_type: 'ParticipantClefTask')

      pct_migration_mappings.each do |migration_mapping|
        pct = ParticipantClefTask.where(id: migration_mapping['source_id']).first
        pct&.update(participant_id: @new_id)
      end

      MigrationMapping.create!(crowdai_participant_id: @old_id, source_id: @new_id, source_type: 'Participant')
    end
  end


  def undo_migration
    user_migration = MigrationMapping.where(crowdai_participant_id: @old_id, source_id: @new_id, source_type: 'Participant').first
    raise "User Not Migrated" if user_migration.nil?

    ActiveRecord::Base.transaction do
      submission_migration_mappings = MigrationMapping.where(crowdai_participant_id: @old_id, source_type: 'Submission')

      submission_migration_mappings.each do |migration_mapping|
        submission = Submission.where(id: migration_mapping['source_id']).first
        submission.update(participant_id: nil)
      end

      cp_migration_mappings = MigrationMapping.where(crowdai_participant_id: @old_id, source_type: 'ChallengeParticipant')
      cp_migration_mappings.each do |migration_mapping|
        cp = ChallengeParticipant.where(id: migration_mapping['source_id']).first
        cp.update(participant_id: nil)
      end

      pct_migration_mappings = MigrationMapping.where(crowdai_participant_id: @old_id, source_type: 'ParticipantClefTask')
      pct_migration_mappings.each do |migration_mapping|
        pct = ParticipantClefTask.where(id: migration_mapping['source_id']).first
        pct.update(participant_id: nil)
      end

      user_migration.destroy
    end
  end
end