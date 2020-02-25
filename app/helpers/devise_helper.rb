module DeviseHelper
  def devise_mapping
    Devise.mappings[:participant]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html =  "<div class='alert alert-warning alert-dismissible fade show' role='alert'>"
    html << "<div class='container-fluid'>".html_safe
    html << messages
    html << "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>".html_safe
    html << "<span aria-hidden='true'>&times;</span>".html_safe
    html << "</button>".html_safe
    html << "</div>".html_safe
    html << "</div>".html_safe

    html
 end
end
