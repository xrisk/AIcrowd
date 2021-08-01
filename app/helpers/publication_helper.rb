module PublicationHelper
  def check_selected_year(year)
    return false unless params[:years].present?
    params[:years].split(',').map(&:to_i).include?(year)
  end

  def check_selected_venue(venue)
    return false unless params[:venue].present?
    params[:venue].split(',').include?(venue)
  end

  def publication_social_share(site, url, title)
    data_img_and_url = {url: url}
    content_tag(:span,
                data: {
                        title: title,
                        #desc:  challenge.tagline,
                        url:   "#{data_img_and_url[:url]}?utm_source=AIcrowd&utm_medium=#{site.humanize}",
                        href:  "#{data_img_and_url[:url]}?utm_source=AIcrowd&utm_medium=#{site.humanize}"
                      }) do
      social_share_link(site, data_img_and_url[:url])
    end
  end

  def social_share_link(site, data_url)
    link_to "<span class='fa fa-#{site.downcase} #{site.downcase}' style='color: gray;'></span>".html_safe, '#',
      {
        class: "btn btn-secondary new-btn btn-sm mr-1 float-left m-1 #{site.downcase}",
        data: {
                url:       "#{data_url}?utm_source=AIcrowd&utm_medium=#{site.humanize}",
                site:      site,
                toggle:    'tooltip',
                placement: 'top'
               },
        onclick: "return SocialShareButton.share(this)",
        title: "Share to #{site.humanize}",
        rel: 'nofollow'
      }
  end

end