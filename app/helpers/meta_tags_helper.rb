module MetaTagsHelper
  def meta_title
    if content_for?(:meta_title)
      content_for(:meta_title)
    elsif !@page_title.blank?
      "AIcrowd | " + @page_title
    elsif !title_from_controller_name.nil?
      "AIcrowd | " + title_from_controller_name
    else
      DEFAULT_META["meta_title"]
    end
  end

  def meta_description
    return @submission.challenge.tagline if submissions?
    content_for?(:meta_description) ? content_for(:meta_description) : DEFAULT_META["meta_description"]
  end

  def meta_image
    return s3_url_for_image
    meta_image = (content_for?(:meta_image) ? content_for(:meta_image) : DEFAULT_META["meta_image"])
    # little twist to make it work equally with an asset or a url
    meta_image.starts_with?("http") ? meta_image : url_to_image(meta_image)
  end

  def submissions?
    title_from_controller_name == 'Submissions' && @submission
  end

  def having_media_large_or_thumbnail?(submission)
    submission.media_large.present? || submission.media_thumbnail.present?
  end

  def s3_url_for_image
    s3_public_url(@submission, :large) if submissions? && having_media_large_or_thumbnail?(@submission)
  end  

  private

  def title_from_controller_name
    case controller.controller_name
    when 'challenges'
      'Challenges'
    when 'leaderboards'
      'Leaderboard'
    when 'dataset_files'
      'Dataset'
    when 'task_dataset_files'
      'Task Dataset'
    when 'participant_challenges'
      'Participants'
    when 'winners'
      'Winners'
    when 'submissions'
      'Submissions'
    when 'clef_tasks'
      'Tasks'
    when 'blogs'
      'Blog'
    end
  end

  def s3_public_url(mediable, size)
    url = if size == :large
            S3Service.new(mediable.media_large).public_url
          else
            S3Service.new(mediable.media_thumbnail).public_url
          end
  end
end
