ActiveAdmin.register ChallengeCall do
  sidebar 'Details', only: [:show, :edit] do
    ul do
      li link_to 'Responses', admin_challenge_call_challenge_call_responses_path(challenge_call)
    end
  end

  batch_action :acknowledge do |ids|
    batch_action_collection.find(ids).each do |challenge_call|
      challenge_call.update!(acknowledged: true)
    end
    redirect_to admin_challenge_calls_path, notice: 'The challenge calls are acknowledged successfully'
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def permitted_params
      params.permit!
    end
  end

  filter :organizer, as: :select, collection: Organizer.all.map { |organizer| [organizer.organizer, organizer.id] }
  filter :headline

  index do
    selectable_column
    column :id
    column :title
    column 'organizer' do |res|
      res.organizer.organizer
    end
    column :headline
    column :closing_date
    column :website
    column :reponses do |res|
      res.challenge_call_responses.count
    end
    column :acknowledged
    column 'link' do |res|
      "https://www.aicrowd.com/call-for-challenges/#{res.slug}/apply"
    end
    actions
  end

  form do |f|
    f.inputs 'Challenge Call' do
      f.input :title
      f.input :organizer, as: :select, member_label: :organizer
      f.input :headline
      f.label 'Description', class: 'ckeditor_label challenge_call'
      f.text_area :description, class: 'ckeditor'
      f.input :closing_date
      f.input :website
      f.input :slug, input_html: { disabled: true }
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row 'organizer' do |res|
        res.organizer.organizer
      end
      row :headline
      row 'description' do |res|
        simple_format(res.description)
      end
      row :closing_date
      row :website
      row :slug
      row :crowdai
      row 'link' do |res|
        "https://www.crowdai.org/call-for-challenges/#{res.slug}/apply"
      end
      row :acknowledged
    end
  end
end
