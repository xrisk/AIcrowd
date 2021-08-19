class ReputationChangeObserver
  def update(changed_data)
    description = changed_data[:description]

    # If user is your meritable model, you can query for it doing:
    participant = Participant.where(sash_id: changed_data[:sash_id]).first
    aicrowd_badge = AicrowdBadge.find_by_name(changed_data[:name])

    NotificationService.new(participant.id, aicrowd_badge, 'badge').call


    # When did it happened:
    datetime = changed_data[:granted_at]
  end
end