ActiveAdmin.register PaperTrail::Version do
  actions :index, :show

  show do
    columns do
      link_to "Back to #{paper_trail_version.item_type}", request.referer
    end

    h3 "#{paper_trail_version.item_type} changes:"

    table_for changes_hashmap(paper_trail_version.changeset), class: 'papertrail-versions__table' do
      column 'Field Name', :field_name
      column 'Previous Value', :previous_value, class: 'papertrail-versions__previous-column'
      column 'Current Value', :current_value, class: 'papertrail-versions__current-column'
    end
  end
end

def changes_hashmap(changeset)
  changeset.map do |key, value|
    {
      field_name:     key,
      previous_value: value.first,
      current_value:  value.second
    }
  end
end
