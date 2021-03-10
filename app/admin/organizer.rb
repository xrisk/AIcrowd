ActiveAdmin.register Organizer do

   jcropable

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    selectable_column
    column :id
    column :organizer
    column :approved
    column :clef_organizer
    actions
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def permitted_params
      params.permit!
    end
  end

  form do |f|
    f.inputs do
      f.input :organizer
      f.input :address
      f.input :description
      f.input :approved
      f.input :slug
      f.input :image_file, as: :jcropable
      f.input :tagline
      f.input :challenge_proposal
      f.input :api_key
      f.input :clef_organizer
    end
    f.actions
  end

  action_item :details, only: :show do
    link_to 'Organizer Details', organizer_path(params[:id])
  end
end
