if Rails.env == 'development' || Rails.env == 'staging'
  organizers = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/organizers.json'))['organizers']
  challenges = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/challenges.json'))['challenges']
  challenge_rounds = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/challenge_rounds.json'))['challenge_rounds']
  submissions = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/submissions.json'))['submissions']
  challenge_participants = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/challenge_participants.json'))['challenge_participants']


  organizers.each do |org|
    loop_organizer = Organizer.create!({tagline: 'tagline', organizer: org['organizer']})
    selected_chals = challenges.select { |c| c['organizer_id'] == org['id'] }
    selected_chals.each do |chal|
      loop_challenge = Challenge.create!({
                                         organizer_id: loop_organizer.id,
                                         challenge: chal['challenge'],
                                         prize_cash: "",
                                         prize_academic: "",
                                         prize_misc: "",
                                         status_cd: chal['status_cd'],
                                         tagline: chal['tagline'],
                                         primary_sort_order_cd: chal['primary_sort_order_cd'],
                                         secondary_sort_order_cd: chal['secondary_sort_order_cd'],
                                         perpetual_challenge: chal['perpetual_challenge'],
                                         page_views: chal['page_views'],
                                         participant_count: chal['participant_count'],
                                         score_title: chal['score_title'],
                                         score_secondary_title: chal['score_secondary_title'],
                                         slug: chal['slug'],
                                         submission_license: chal['submission_license'],
                                         api_required: chal['api_required'],
                                         media_on_leaderboard: chal['media_on_leaderboard'],
                                         challenge_client_name: chal['challenge_client_name'],
                                         description_markdown: chal['description_markdown']
                                     })
      selected_chal_rounds = challenge_rounds.select { |cr| cr['challenge_id'] == chal['id'] }

      selected_chal_rounds.each do |chal_round|
        loop_challenge_round = ChallengeRound.create!({
                                                      submission_limit: 5,
                                                      submission_limit_period: :day,
                                                      challenge_id: loop_challenge.id,
                                                      challenge_round: chal_round['challenge_round'],
                                                      active: chal_round['active']
                                                  })

        # TODO: Verify condition!
        selected_chal_participants = challenge_participants.select { |cp| cp['challenge_id'] == chal['id'] }

        selected_chal_participants.each do |chal_participant|
          loop_challenge_participant = ChallengeParticipant.create!({challenge_id: loop_challenge.id,
                                                                participant_id: nil,
                                                                name: "Unknown User",
                                                                email: chal_participant['email'],
                                                                registered: chal_participant['registered'],
                                                                accepted_dataset_toc: chal_participant['accepted_dataset_toc']})
          MigrationMapping.create!(
              source_type: 'ChallengeParticipant',
              source_id: loop_challenge_participant.id,
              crowdai_participant_id: chal_participant['participant_id']
          )
        end

        # TODO: Verify condition!
        selected_submissions = submissions.select { |s| s['challenge_round_id'] == chal_round['id'] }

        selected_submissions.each do |sub|
          loop_submission = Submission.create!({
                                              participant_id: nil,
                                              challenge_id: loop_challenge.id,
                                              grading_status_cd: sub['grading_status_cd'],
                                              challenge_round_id: loop_challenge_round.id,
                                              score: sub['score'],
                                              created_at: sub['created_at'],
                                              updated_at: sub['updated_at'],
                                              baseline: false,
                                              score_secondary: sub['score_secondary'],
                                              description_markdown: sub['description_markdown']
                                          })

          MigrationMapping.create!([{
                                        source_type: 'Submission',
                                        source_id: loop_submission.id,
                                        crowdai_participant_id: sub['participant_id']}
                                   ])

        end
      end
    end

  end
end
