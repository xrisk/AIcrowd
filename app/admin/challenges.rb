ActiveAdmin.register Challenge, as: 'Editors Selection' do
  scope_to do
    Challenge.editors_selections
  end

  filter :id
  filter :status_cd
  filter :challenge

  index do
    selectable_column
    column :id
    column :challenge
    column :status
    column :featured_sequence
    column :page_views
    column :participant_count
    column :submissions_count
    column :practice_flag

    actions default: true do |resource|
      a 'Edit', href: edit_challenge_path(resource), class: 'edit_link member_link'
    end
  end

  controller do
    actions :all, except: [:new, :edit]

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def permitted_params
      params.permit!
    end
  end

  member_action :purge, method: :delete do
    submissions       = Submission.where(challenge_id: params[:id])
    submissions_count = submissions.count
    submissions.destroy_all
    redirect_to admin_challenge_path(params[:id]), flash: { notice: "#{submissions_count} submissions have been deleted." }
  end

  action_item :edit, only: :show do
    link_to 'Edit', edit_challenge_path(resource)
  end

  batch_action 'Remove Editors Selection', priority: 1 do |ids|
    Challenge.find(ids).each do |challenge|
      challenge.update!(editors_selection: false)
    end
    redirect_to admin_editors_selections_path, flash: { notice: "Remove editors selection to challenge #{ids}." }
  end
end
