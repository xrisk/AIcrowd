module ImagesHelper
  def image_url(model)
    if model.image_file
      image_url = model.image_file.url
      image_url = default_image_url if image_url.nil?
    else
      image_url = default_image_url
    end
  end

  def default_image_url
    image_path get_default_image
  end

  def get_default_image
    num = model.id % 8
    "users/AIcrowd-DarkerBG (#{num}).png"
  end

  def challenge_default_image_url
    image_path 'users/user-avatar-default.svg'
  end
end
