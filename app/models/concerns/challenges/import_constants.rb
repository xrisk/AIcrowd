module Challenges
  module ImportConstants
    IMPORTABLE_FIELDS = [
      :challenge,
      :challenge_client_name,
      :status_cd,
      :tagline,
      :perpetual_challenge,
      :answer_file_s3_key,
      :slug,
      :submission_license,
      :api_required,
      :media_on_leaderboard,
      :online_grading,
      :description_markdown,
      :description,
      :evaluation_markdown,
      :evaluation,
      :rules_markdown,
      :rules,
      :prizes_markdown,
      :prizes,
      :resources_markdown,
      :resources,
      :submission_instructions_markdown,
      :submission_instructions,
      :license_markdown,
      :license,
      :dataset_description_markdown,
      :dataset_description,
      :dynamic_content_flag,
      :dynamic_content,
      :dynamic_content_tab,
      :winner_description_markdown,
      :winner_description,
      :winners_tab_active,
      :clef_challenge,
      :submissions_page,
      :private_challenge,
      :show_leaderboard,
      :grader_identifier,
      :online_submissions,
      :evaluator_type_cd,
      :grader_logs,
      :require_registration,
      :grading_history,
      :submissions_downloadable,
      :dataset_note_markdown,
      :dataset_note,
      :discussions_visible,
      :require_toc_acceptance,
      :toc_acceptance_text,
      :toc_acceptance_instructions,
      :toc_acceptance_instructions_markdown,
      :toc_accordion,
      :dynamic_content_url,
      :prize_cash,
      :prize_travel,
      :prize_academic,
      :prize_misc,
      :latest_submission,
      :other_scores_fieldnames,
      :teams_allowed,
      :max_team_participants,
      :team_freeze_seconds_before_end,
      :hidden_challenge,
      :team_freeze_time,
      :clef_task_id,
      :scrollable_overview_tabs,
      :meta_challenge,
      :banner_color,
      :big_challenge_card_image,
      :practice_flag
    ].freeze

    IMPORTABLE_ASSOCIATIONS = {
      challenges_organizers_attributes: [
        :organizer_id
      ],
      category_challenges_attributes: [
        :category_id
      ],
      submission_file_definitions_attributes: [
        :seq,
        :submission_file_description,
        :filetype_cd,
        :file_required,
        :submission_file_help_text
      ],
      challenge_partners_attributes: [
        :partner_url
      ],
      challenge_rules_attributes: [
        :terms,
        :terms_markdown,
        :instructions,
        :instructions_markdown,
        :has_additional_checkbox,
        :additional_checkbox_text,
        :additional_checkbox_text_markdown,
        :version
      ],
      dataset_files_attributes: [
        :id,
        :seq,
        :description,
        :dataset_file_s3_key,
        :evaluation,
        :title,
        :hosting_location,
        :external_url,
        :visible,
        :external_file_size,
        :file_path,
        :aws_access_key,
        :aws_secret_key,
        :bucket_name,
        :region
      ]
    }.freeze

    RESETTABLE_ASSOCIATIONS = [
      :challenges_organizers,
      :category_challenges,
      :submission_file_definitions,
      :challenge_partners,
      :challenge_rules,
    ].freeze

    IMPORTABLE_IMAGES = [
      :image_file,
      :banner_file,
      challenge_partners: :image_file
    ]
  end
end
