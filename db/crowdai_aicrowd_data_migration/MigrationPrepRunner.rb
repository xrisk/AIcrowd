if Rails.env == 'development' || Rails.env == 'staging'
  # Turn off logger
  #old_logger = ActiveRecord::Base.logger
  #ActiveRecord::Base.logger = nil

  # Fetch objects from the Saved Json Files
  organizers = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/organizers.json'))['organizers']
  challenges = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/challenges.json'))['challenges']
  challenge_rounds = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/challenge_rounds.json'))['challenge_rounds']
  submissions = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/submissions.json'))['submissions']
  challenge_participants = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/challenge_participants.json'))['challenge_participants']
  clef_tasks = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/clef_tasks.json'))['clef_tasks']
  participant_clef_tasks = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/participant_clef_tasks.json'))['participant_clef_tasks']
  task_dataset_files = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/task_dataset_files.json'))['task_dataset_files']

  models = [Organizer, Challenge, ChallengeRound, Submission, ChallengeParticipant, TaskDatasetFile, ParticipantClefTask, ClefTask]

  models.each do |model|
    ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
  end


  ActiveRecord::Base.transaction do
    # For each Organizer 'org'
    organizers.each do |org|
      # Remove ID from Hash so that we get a new ID
      org_old_id = org['id']
      org.delete("id")
      # Add Tagline as it is needed
      org['tagline'] ||= org['organizer']
      # Create a new organizer from Hash
      loop_organizer = Organizer.create!(org)
      # Select all the challenges for org
      selected_chals = challenges.select { |c| c['organizer_id'] == org_old_id }
      selected_clef_tasks = clef_tasks.select { |clt| clt['organizer_id'] == org_old_id }

      selected_clef_tasks.each do |clef_task|
        clef_task_old_id = clef_task["id"]
        clef_task.delete("id")
        clef_task["organizer_id"] = loop_organizer.id
        loop_clef_task = ClefTask.create!(clef_task)

        MigrationMapping.create!(
            source_type: 'ClefTask',
            source_id: loop_clef_task.id,
            crowdai_participant_id: clef_task_old_id
        )
        selected_pcts = participant_clef_tasks.select { |pct| pct['clef_task_id'] == clef_task_old_id }
        selected_pcts.each do |pct|
          pct_old_id = pct["id"]
          pct.delete("id")
          pct.delete("participant_id")
          pct["clef_task_id"] = loop_clef_task.id
          loop_pct = ParticipantClefTask.create!(pct)

          MigrationMapping.create!(
              source_type: 'ParticipantClefTask',
              source_id: loop_pct.id,
              crowdai_participant_id: pct_old_id
          )
        end

        selected_tdfs = task_dataset_files.select { |tdf| tdf['clef_task_id'] == clef_task_old_id }
        selected_tdfs.each do |tdf|
          tdf_old_id = tdf["id"]
          tdf.delete("id")
          tdf["clef_task_id"] = loop_clef_task.id
          loop_tdf = TaskDatasetFile.create!(tdf)

          MigrationMapping.create!(
              source_type: 'TaskDatasetFile',
              source_id: loop_tdf.id,
              crowdai_participant_id: tdf_old_id
          )
        end
      end

      selected_chals.each do |chal|
        chal_old_id = chal["id"]
        chal.delete("id")
        chal.delete("featured_sequence")
        chal.delete("submission_count")
        chal["status_cd"] = "draft"
        chal["organizer_id"] = loop_organizer.id
        chal["hidden_challenge"] = true
        chal["prize_cash"] = ""
        chal["prize_academic"] = ""
        chal["prize_misc"] = ""
        if chal["secondary_sort_order_cd"].blank?
          chal["secondary_sort_order_cd"] = "ascending"
        end

        # create a new challenge
        Challenge.skip_callback(:create, :after)
        loop_challenge = Challenge.create!(chal)
        Challenge.set_callback(:create, :after)

        MigrationMapping.create!(
            source_type: 'Challenge',
            source_id: loop_challenge.id,
            crowdai_participant_id: chal_old_id
        )

        # Select all rounds for current challenge
        selected_chal_rounds = challenge_rounds.select { |cr| cr['challenge_id'] == chal_old_id }

        selected_chal_rounds.each do |chal_round|
          old_chal_round_id = chal_round["id"]
          chal_round.delete("id")
          chal_round["challenge_id"] = loop_challenge.id
          chal_round["submission_limit"] = 5
          chal_round["submission_limit_period"] = "day"

          loop_challenge_round = ChallengeRound.create!(chal_round)

          selected_chal_participants = challenge_participants.select { |cp| cp['challenge_id'] == chal_old_id }

          MigrationMapping.create!(
              source_type: 'ChallengeRound',
              source_id: loop_challenge_round.id,
              crowdai_participant_id: old_chal_round_id
          )

          selected_chal_participants.each do |chal_participant|
            old_participant_id = chal_participant["participant_id"]
            chal_participant.delete("id")
            chal_participant.delete("participant_id")
            chal_participant["challenge_id"] = loop_challenge.id
            chal_participant["name"] = "Unknown User"

            loop_challenge_participant = ChallengeParticipant.create!(chal_participant)

            MigrationMapping.create!(
                source_type: 'ChallengeParticipant',
                source_id: loop_challenge_participant.id,
                crowdai_participant_id: old_participant_id
            )
          end

          selected_submissions = submissions.select { |s| s['challenge_round_id'] == old_chal_round_id }

          selected_submissions.each do |sub|
            old_participant_id = sub["participant_id"]
            sub.delete("id")
            sub.delete("participant_id")
            sub["challenge_id"] = loop_challenge.id
            sub["challenge_round_id"] = loop_challenge_round.id
            sub["grading_message"] = sub["grading_message"].nil? ? nil : "\nGrading " + sub["grading_message"].capitalize

            # Until Round Processing is done, we dont want to
            # queue the leaderboard job, so we set below key = true

            if sub["meta"].is_a? Hash
              sub["meta"]["private_ignore-leaderboard-job-computation"] = true
              sub["meta"].delete("repo_url")
            else
              sub["meta"] = {"private_ignore-leaderboard-job-computation": true}
            end

            loop_submission = Submission.create!(sub)

            MigrationMapping.create!(
                source_type: 'Submission',
                source_id: loop_submission.id,
                crowdai_participant_id: old_participant_id
            )
          end
          # Round Processing done, lets queue the leaderboard job
          CalculateLeaderboardJob.perform_later(challenge_round_id: loop_challenge_round)
        end
      end
    end
  end

  # Turn on logger
  #ActiveRecord::Base.logger = old_logger
end
