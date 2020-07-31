module MediaHelper
  def media_content_type(mediable)
    return nil if mediable.media_content_type.nil?

    media        = mediable.media_content_type.split('/')
    content_type = media[0]
    file_type    = media[1]
    return file_type if file_type == 'youtube'

    content_type = nil if ['video', 'image'].exclude?(content_type)
    content_type
  end

  def thumb_media_content_type(mediable)
    return nil if mediable.media_thumbnail.nil? || !mediable.media_thumbnail.include?('.')

    media     = mediable.media_thumbnail.split('.')
    file_type = media[1]

    return 'youtube' if mediable.media_content_type&.split('/')&.last == 'youtube'
    return 'image' if ['png', 'jpg', 'gif'].include?(file_type)
    return 'video' if ['mp4', 'webM'].include?(file_type)
  end

  def media_asset(mediable, content_type, size)
    case content_type
    when nil
      '-'
    when 'image'
      render_image(mediable, size)
    when 'video'
      render_video(mediable, size)
    when 'youtube'
      render_youtube(mediable, size)
    end
  end

  private

  def dimensions(size)
    return '100x75' if size == :thumb
    return '800x600' if size == :large
  end

  def render_image(mediable, size)
    if s3_public_url(mediable, size).present?
      image_tag(s3_public_url(mediable, size), size: dimensions(size), class: 'media')
    else
      '-'
    end
  end

  def render_video(mediable, size)
    if s3_public_url(mediable, size).present?
      if size == :large
        video_tag(s3_public_url(mediable, size), size: dimensions(size), controls: true, muted: true, autoplay: true, loop: true, class: 'media')
      else
        video_tag(s3_public_url(mediable, size), size: dimensions(size), autoplay: true, muted: true, loop: true, class: 'media')
      end
    else
      '-'
    end
  end

  def render_youtube(mediable, size)
    if size == :thumb && mediable.media_thumbnail.present?
      url = "https://img.youtube.com/vi/#{mediable.media_thumbnail}/0.jpg"
      return image_tag(url, size: '100x75', class: 'media')
    end
    if size == :large && mediable.media_large.present?
      result = %(
        <iframe title="AIcrowd Video"
          allowfullscreen="allowfullscreen"
          mozallowfullscreen="mozallowfullscreen"
          msallowfullscreen="msallowfullscreen"
          oallowfullscreen="oallowfullscreen"
          webkitallowfullscreen="webkitallowfullscreen"
          width="800"
          height="600"
          src="//www.youtube.com/embed/#{mediable.media_large}"
          frameborder="0"
          allowfullscreen>
        </iframe>
      )
      result.html_safe
    end
  end

  def s3_public_url(mediable, size)
    url = if size == :large
            S3Service.new(mediable.media_large).public_url
          else
            S3Service.new(mediable.media_thumbnail).public_url
          end
  end

  def content_type_is_image?(mediable)
    media_content_type(mediable) == 'image'
  end

  def having_media_large?(challenge, mediable)
    challenge.media_on_leaderboard && mediable.media_large.present?
  end

  def having_media_thumb?(challenge, mediable)
    challenge.media_on_leaderboard && mediable.media_thumbnail.present?
  end

  def having_media_large_image?(challenge, mediable)
    having_media_large?(challenge, mediable) && content_type_is_image?(mediable)
  end

  def having_media_thumbnail_image?(challenge, mediable)
    having_media_thumb?(challenge, mediable) && content_type_is_image?(mediable)
  end
end
