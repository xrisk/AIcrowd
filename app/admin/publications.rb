ActiveAdmin.register Publication do
  permit_params(:id,
    :title,
    :thumbnail,
    :description,
    :challenge_id,
    :publication_date,
    :no_of_citations,
    :aicrowd_contributed,
    publication_venues_attributes:[
    :id,
    :venue
    ],
    publication_authors_attributes:[
    :id,
    :name,
    :participant_id
    ],
    publication_external_links_attributes:[
    :id,
    :link
    ]
  )

  controller do

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :thumbnail
      f.input :challenge,
              as:         :searchable_select,
              collection: Challenge.all.map { |challenge|
                            [challenge.challenge, challenge.id]
                          }
      f.input :publication_date
      f.input :no_of_citations
      f.input :aicrowd_contributed
      f.label 'Description', class: 'ckeditor_label job_posting'
      f.text_area :description, class: 'ckeditor'
    end

    f.inputs do
      f.has_many :publication_authors, heading: 'Authors' do |a|
        a.input :name
        a.input :participant_id,
              label:      'Participant',
              as:         :searchable_select,
              collection: Participant.all.order(:name).map { |u| ["#{u.name} - #{u.id}", u.id] }
      end
    end
    f.inputs do
      f.has_many :publication_venues, heading: 'Venue' do |a|
        a.input :venue
      end
    end
    f.inputs do
      f.has_many :publication_external_links, heading: 'External Link' do |a|
        a.input :link
      end
    end
    f.actions
  end
end
