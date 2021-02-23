ActiveAdmin.register Publication do
  config.filters = false
  permit_params(:id,
     :title,
     :thumbnail,
     :description,
     :abstract,
     :challenge_id,
     :publication_date,
     :no_of_citations,
     :aicrowd_contributed,
     :sequence,
     :cite,
     venues_attributes:[
      :id,
      :venue,
      :short_name,
      :_destroy
     ],
     authors_attributes:[
      :id,
      :name,
      :participant_id,
      :sequence,
      :_destroy
     ],
     external_links_attributes:[
      :id,
      :name,
      :link,
      :icon,
      :_destroy
     ]
  )

  before_action :update_tags, only: [:update]

  controller do

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def update_tags
      if params["publication"]["categories_attributes"].present?
        publication = Publication.friendly.find(params["id"])
        publication.category_publications.destroy_all if publication.category_publications.present?

        params["publication"]["categories_attributes"].each do |key, category|
          category = Category.find_or_create_by(name: category["name"])
          if category.save
            publication.category_publications.create!(category_id: category.id)
          else
            publication.errors.messages.merge!(category.errors.messages)
          end
        end

      end
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :thumbnail
      f.input :abstract
      f.input :cite
      f.input :challenge
              # as:         :searchable_select,
              # collection: Challenge.all.map { |challenge|
              #               [challenge.challenge, challenge.id]
              #             }
      f.input :publication_date
      f.input :no_of_citations
      f.input :aicrowd_contributed
      f.input :sequence
      f.label 'Description', class: 'ckeditor_label job_posting'
      f.text_area :description, class: 'ckeditor'
    end

    f.inputs do
      f.has_many :authors, heading: 'Authors', allow_destroy: true do |a|
        a.input :name
        a.input :sequence
        a.input :participant_id
              # label:      'Participant',
              # as:         :searchable_select,
              # collection: Participant.all.order(:name).map { |u| ["#{u.name} - #{u.id}", u.id] }
      end
    end
    f.inputs do
      f.has_many :venues, heading: 'Venue', allow_destroy: true do |a|
        a.input :venue
        a.input :short_name
      end
    end
    f.inputs do
      f.has_many :external_links, heading: 'External Link', allow_destroy: true do |a|
        a.input :name
        a.input :link
        a.input :icon
      end
    end
    f.inputs do
      f.has_many :categories, heading: 'Tags' do |a|
        a.input :name
      end
    end
    f.actions
  end
end
