ActiveAdmin.register Setting do
  controller do
    def permitted_params
      params.permit!
    end
  end

  form do |f|
    f.inputs do
      f.input :jobs_visible
      f.label 'Banner text', class: 'ckeditor_label challenge call'
      f.text_area :banner_text, class: 'ckeditor'
      f.input :banner_color
      f.actions
    end
  end
end
