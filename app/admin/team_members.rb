ActiveAdmin.register TeamMember do
  config.sort_order = 'seq_asc'

  controller do
    def permitted_params
      params.permit!
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :seq
    column :title
    column :description
    column :section
    column :participant
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.object.section     ||= "Main"
    f.object.description ||= "This field is unused right now!"
    f.object.seq         ||= (TeamMember.maximum(:seq) || 0) + 1
    f.inputs do
      f.input :name
      f.input :title
      f.input :description
      f.input :section
      f.input :participant, as: :string, input_html: { value: f.object&.participant&.name.presence || '' }
      f.input :seq
    end
    f.actions
  end

  controller do

    def update
      model = :team_member
      participant = Participant.find_by_name(params[:team_member][:participant])
      if participant.blank?
        flash[:info] = "Participant not found"
        return redirect_to admin_team_members_path
      end
      params[:team_member][:participant] = participant
      super
    end
  end
end
