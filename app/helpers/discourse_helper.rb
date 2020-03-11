module DiscourseHelper
  def discourse_category_url(slug)
    "#{ENV['DISCOURSE_DOMAIN_NAME']}/c/#{slug}"
  end

  def discourse_topic_url(slug)
    "#{ENV['DISCOURSE_DOMAIN_NAME']}/t/#{slug}"
  end

  def discourse_post_url(topic_slug, post_number)
    "#{ENV['DISCOURSE_DOMAIN_NAME']}/t/#{topic_slug}/#{post_number}"
  end

  def discourse_post_datetime(post_created_at)
    time_ago_in_words = time_ago_in_words(post_created_at)

    if time_ago_in_words == '1 day'
      'Yesterday'
    else
      "#{time_ago_in_words.capitalize} ago"
    end
  end
end
