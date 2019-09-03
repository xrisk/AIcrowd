ActiveAdmin.register TeamParticipant do
  menu false
  belongs_to :team, finder: :find_by_name

  controller do
    def scoped_collection
      super.includes :team, :participant
    end
  end

  index do
    selectable_column
    column :participant
    column :role
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :participant
      row :role
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :participant, collection: Participant.order(:slug).pluck(:slug, :id)
      f.input :role, as: :select, collection: TeamParticipant::ROLES.map { |x| [x.to_s.titleize, x] }
    end
    f.actions
  end
end
