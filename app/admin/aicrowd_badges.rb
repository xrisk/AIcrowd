ActiveAdmin.register AicrowdBadge do
  permit_params :id, :name, :description, :badge_type_id, :code, :badges_event_id

  sidebar 'Badge versions', only: [:show, :edit] do
    ul do
      aicrowd_badge.versions.reverse.each do |version|
        li link_to version.created_at.to_s, admin_paper_trail_version_path(version)
      end
    end
  end
end
