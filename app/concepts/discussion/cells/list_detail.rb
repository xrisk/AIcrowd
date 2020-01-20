class Discussion::Cell::ListDetail < Discussion::Cell
  def show
    render :list_detail
  end

  def topic
    model
  end

  def challenge
    @challenge ||= topic.challenge
  end

  def author
    @author ||= topic.participant
  end

  def participant_link
    link = if topic.participant.present?
            "Posted by #{link_to author.name, participant_path(author)} "
           else
            "Posted by #{link_to '<< redacted >>', '#'} "
           end
    return link
  end
end
