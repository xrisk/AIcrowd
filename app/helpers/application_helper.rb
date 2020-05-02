module ApplicationHelper
  def rewrite_type(key)
    case key
    when 'notice'
      'success'
    when 'success'
      'success'
    when 'info'
      'info'
    when 'alert'
      'warning'
    when 'error'
      'warning'
    when 'flash'
      'flash'
    end
  end

  def body_id
    if (controller.controller_name == 'landing_page' && controller.action_name == 'index') ||
       (controller.controller_name == 'blogs' && controller.action_name == 'index')
      return 'home'
    else
      return nil
    end
  end

  def footer_class
    if controller.controller_name == 'registrations' ||
        (controller.controller_name == 'challenges' && controller.action_name == 'edit') ||
        (controller.controller_name == 'organizers' && controller.action_name == 'edit') ||
        (controller.controller_name == 'sessions')
      return "class='no-margin-top'"
    else
      return nil
    end
  end

  def themed_button(opts = {})
    raise ArgumentError if opts.key?(:link) && opts.key?(:modal)

    title = opts[:title].to_s
    unless opts[:disabled]
      confirm = opts[:confirm]
      modal   = opts[:modal] if opts[:modal]
      if opts[:link]
        url    = begin
                opts.dig(:link, :url)
                 rescue StandardError
                   nil || opts.dig(:link)
              end
        method = begin
                   opts.dig(:link, :method)
                 rescue StandardError
                   nil || :get
                 end
      end
    end

    outer         = {}
    outer[:class] = opts[:class] if opts[:class]
    if opts[:tooltip]
      outer.deep_merge!({
                          title: opts[:tooltip],
                          data:  {
                            toggle: 'tooltip'
                          }
                        })
    end

    inner_type = :button
    inner      = {
      disabled: opts[:disabled],
      class:    "btn btn-secondary"
    }
    inner[:class] += ' disabled' if opts[:disabled]
    inner[:class] += ' btn-sm' if opts[:small]
    if url
      inner_type = :a
      inner.deep_merge!({
                          href: url,
                          data: {
                            method: method,
                            **(confirm ? { confirm: confirm } : {})
                          }
                        })
    elsif modal
      inner.deep_merge!({
                          type: 'button',
                          data: {
                            toggle: 'modal',
                            target: modal
                          }
                        })
    end

    content_tag(:span, outer) { content_tag(inner_type, inner) { title } }
  end

  def social_share(site, challenge, mediable)
    if mediable.class.name == 'Leaderboard'
      data_url = "#{request.url}"
      img = having_media_thumbnail_image?(challenge, mediable) ? s3_public_url(mediable, :thumb) : nil
    elsif mediable.class.name == 'Submission'
      data_url = "#{request.base_url}/#{mediable.short_url}" if mediable.class.name == 'Submission'
      img = having_media_large_image?(challenge, mediable) ? s3_public_url(mediable, :large) : nil
    end
    content_tag(:span,
                data: {
                        title: challenge.challenge,
                        desc: challenge.tagline,
                        img: img,
                        url: data_url + "?utm_source=AIcrowd&utm_medium=#{site.humanize}"
                      }) do
      social_share_link(site, data_url) do
        image_tag(social_image_url(site))
      end
    end
  end

  def social_share_link(site, data_url)
    link_to image_tag(social_image_url(site)), '#',
      {
        class: "btn btn-#{site} btn-sm mr-2",
        data: {
                url: data_url.concat("?utm_source=AIcrowd&utm_medium=#{site.humanize}"),
                site: site,
                toggle: 'tooltip',
                placement: 'top'
               },
        onclick: "return SocialShareButton.share(this)",
        title: "Share to #{site.humanize}",
        rel: 'nofollow'
      }
  end

  def social_image_url(site)
    "/assets/img/icon-#{site}.svg"
  end

  def banner_text
    Setting.banner_record&.gsub('<p>', '')&.gsub('</p>', '')&.html_safe
  end

  def banner_color
    Setting.banner_color_value
  end

  def footer_text
    Setting.footer_record
  end
end
