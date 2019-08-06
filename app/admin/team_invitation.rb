ActiveAdmin.register TeamInvitation do
  menu false
  actions :index
  belongs_to :team, finder: :find_by_name

  controller do
    def scoped_collection
      super.includes :team, :invitor, :invitee
    end
  end

  index do
    selectable_column
    column :team, sortable: 'team.name'
    column :invitor, sortable: 'invitor.slug'
    column :invitee, sortable: 'invitee.slug'
    column :status
    column :uuid
    column :created_at
    column :updated_at
    actions
  end
end
