module SanitizationHelper
  def sanitize_html(html_content)
    Sanitize.fragment(html_content, Sanitize::Config::RELAXED).html_safe
  end
end
