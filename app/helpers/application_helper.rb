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

  def social_share(site, challenge, mediable, text=nil)
    title = text.presence || challenge.challenge
    data_img_and_url = data_image_and_url(challenge, mediable)
    content_tag(:span,
                data: {
                        title: title,
                        desc: challenge.tagline,
                        img: data_img_and_url[:img],
                        url: data_img_and_url[:url] + "?utm_source=AIcrowd&utm_medium=#{site.humanize}",
                        href: data_img_and_url[:url] + "?utm_source=AIcrowd&utm_medium=#{site.humanize}"
                      }) do
      social_share_link(site, data_img_and_url[:url]) do
        image_tag(social_image_path(site))
      end
    end
  end


  def social_share_link(site, data_url)
    link_to image_tag(social_image_path(site)), '#',
      {
        class: "btn btn-#{site} btn-sm mr-2 social-share",
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
    raw Setting.banner_record&.gsub('<p>', '')&.gsub('</p>', '')
  end

  def banner_color
    Setting.banner_color_value
  end

  def footer_text
    raw Setting.footer_record
  end

  def notification_time(time)
    if time_in_days(time) >= 1
      "#{pluralize(time_in_days(time), 'day')} Ago"
    elsif time_in_hours(time) > 0
      sanitize_html("#{pluralize(time_in_hours(time), 'hour')} Ago")
    elsif time_in_minutes(time) > 0
      sanitize_html("#{pluralize(time_in_minutes(time), 'minute')} Ago")
    else
      'Just now'
    end
  end

  def time_in_days(time)
    (time_in_seconds(time) / (60 * 60 * 24)).floor
  end

  def time_in_hours(time)
    (time_in_seconds(time) / (60 * 60)).floor
  end

  def time_in_minutes(time)
    (time_in_seconds(time) / 60).floor
  end

  def time_in_seconds(time)
    seconds = Time.current - time
    seconds = 0 if seconds.nil? || seconds < 0
    return seconds
  end

  def social_image_path(site)
    "/assets/img/icon-#{site}.svg"
  end

  def check_notification_status(notifications)
    notifications&.pluck(:is_new)&.uniq&.any?(true) ? 'notification-bell-icon-active' : 'notification-bell-icon'
  end

  def unread_notification?(notification)
    'dropdown-item-active' if notification.is_new
  end

  private

  def data_image_and_url(challenge, mediable)
    data_img_and_url = {}
    if mediable.class.name == 'Leaderboard'
      data_img_and_url.merge!(img: having_media_thumbnail_image?(challenge, mediable) ? s3_public_url(mediable, :thumb) : content_for_meta_image)
      data_img_and_url.merge!(url: challenge_submission_url(challenge, mediable.submission))
    elsif mediable.class.name == 'Submission'
      data_img_and_url.merge!(img: having_media_thumbnail_image?(challenge, mediable) ? s3_public_url(mediable, :thumb) : content_for_meta_image)
      data_img_and_url.merge!(url: challenge_submission_url(challenge, mediable))
    elsif mediable.class.name == 'String'
      data_img_and_url.merge!(url: url_for(mediable))
    end
    data_img_and_url
  end
end
