ActiveAdmin.register Post do
  permit_params :id, title, :tagline, :challenge_id, :submission_id, :thumbnail, :notebook_html, participant_id, :cover_image
end