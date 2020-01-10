class Discussion::Cell::Comment < Discussion::Cell
  def show
    render :comment
  end

  def comment
    model
  end

  def topic
    @topic ||= comment.topic
  end

  def author
    return @author ||= Participant.find(comment.participant_id)
  end

  def admin_actions
    " | #{link_to 'Edit', edit_topic_comment_path(topic, comment), remote: true} | #{link_to 'Delete', topic_comment_path(topic, comment), method: :delete}" if current_participant&.admin?
  end
end
