module MetaTagsHelper
  def meta_title
    if @challenge.present? && controller_name.present? && controller_name != 'challenges'
      "AIcrowd | #{@challenge.challenge} | #{controller_name.capitalize}"
    elsif show_action?
      if controller_name == 'challenges'
        "AIcrowd | " + @challenge.challenge + "| #{controller_name.capitalize}"
      elsif controller_name == 'participants'
        "AIcrowd | " + @participant.slug + "| #{controller_name.capitalize}"
      elsif controller_name == 'organizers'
        "AIcrowd | " + @organizer.slug + "| #{controller_name.capitalize}"
      elsif controller_name == 'submissions'
        "AIcrowd | " + @challenge.challenge + "| #{controller_name.capitalize}"
      end
    elsif content_for?(:meta_title)
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
    return @challenge.tagline if @challenge.present? && controller_name.present?

    if show_action?
      case controller_name
      when 'organizers'
        return @organizer.description
      when 'submissions'
        return @submission.description
      when 'challenges'
        return @challenge.tagline
      when 'participants'
        return @participant.bio
      end
    end
    content_for?(:meta_description) ? content_for(:meta_description) : DEFAULT_META["meta_description"]
  end

  def meta_image
    if show_action?
      if controller_name == 'submissions'
        having_media_large_image?(@challenge, @submission) ? s3_public_url(@submission, :large) : content_for_meta_image
      elsif controller_name == 'challenges' && @challenge.image_file?
        @challenge.image_file.url
      elsif controller_name == 'organizers' && @organizer.image_file?
        @organizer.image_file.url
      elsif controller_name == 'participants' && @participant.image_file?
        @participant.image_file.url
      end
    else
      content_for_meta_image
    end
  end

  private

  def title_from_controller_name
    case controller_name
    when 'organizers'
      'Organizers'
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

  def show_action?
    controller.action_name == 'show'
  end

  def controller_name
    controller.controller_name
  end

  def content_for_meta_image
    meta_image = (content_for?(:meta_image) ? content_for(:meta_image) : DEFAULT_META["meta_image"])
    # little twist to make it work equally with an asset or a url
    meta_image.starts_with?("http") ? meta_image : url_to_image(meta_image)
  end
end
