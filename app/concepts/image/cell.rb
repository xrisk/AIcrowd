class Image::Cell < Template::Cell

  def show
    render
  end

  def klass
    options[:klass]
  end

  def image_url
    if model.image_file
      image_url = model.image_file.url
      if image_url.nil?
        image_url = default_image_url
      end
    else
      image_url = default_image_url
    end
    image_url
  end

  def image
    url = image_url
    image_tag(image_url, class: klass)
  end

  def image_16x9
    url = image_url
    image_tag(image_url, class: klass, style: "position: absolute;object-fit: cover;width: 100%;height: 100%;")
  end

  def default_image_url
    image_path 'users/avatar-default.png'
  end

end
