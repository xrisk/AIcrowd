ActiveAdmin.register Team do
  config.sort_order = 'name_asc'
  permit_params :name, :challenge_id

  controller do
    defaults :finder => :find_by_name
    def scoped_collection
      super.includes :challenge
    end
  end

  sidebar 'Associations', only: [:show, :edit] do
    ul do
      li link_to "Members (#{team.team_participants.count})", admin_team_team_participants_path(team)
      li link_to "Invitations (#{team.team_invitations.count})", admin_team_team_invitations_path(team)
    end
  end

  index do
    selectable_column
    column :name
    column :challenge, sortable: 'challenges.challenge' do |team|
      link_to team.challenge.challenge, admin_challenge_path(team.challenge)
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :challenge do |team|
        link_to team.challenge.challenge, admin_challenge_path(team.challenge)
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name, as: :string
      f.input :challenge, collection: Challenge.all.map { |x| [x.challenge, x.id] }
    end
    f.actions
  end
end
