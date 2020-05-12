ActiveAdmin.register Setting do
  config.clear_action_items!

  controller do
    def permitted_params
      params.permit!
    end
  end

  form do |f|
    f.inputs do
      f.input :jobs_visible
      panel 'Header Banner' do
        f.input :enable_banner
        f.input :banner_text
        f.input :banner_color
      end
      panel 'Footer' do
        f.input :enable_footer
        f.input :footer_text
      end
      f.actions
    end
  end

  action_item :create, only: :index do
    link_to 'Create Setting', new_admin_setting_path unless Setting.first.present?
  end
end
