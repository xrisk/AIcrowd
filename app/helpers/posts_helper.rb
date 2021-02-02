module PostsHelper
  def posts_category_options(post)
    post_category = post.categories.pluck(:name)
    raw_options        = ''
    Category.pluck(:name).each do |category_name|
      if post_category.include?(category_name)
        raw_options << sanitize_html_with_attr("<option selected='selected' value='#{category_name}''>#{category_name.parameterize.underscore}</option>", elements: ['option'], attributes: {'option' => ['selected', 'value']})
      else
        raw_options << sanitize_html_with_attr("<option value='#{category_name}''>#{category_name.parameterize.underscore}</option>", elements: ['option'], attributes: {'option' => ['value']})
      end
    end
    raw(raw_options)
  end

  def votes_on_comment(comment, participant)
    Vote.where(participant_id: participant.id, votable_id: comment.id, votable_type: 'CommontatorComment').first if participant.present?
  end
end
