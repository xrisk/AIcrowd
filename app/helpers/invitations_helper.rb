module InvitationsHelper
  def invitation_amount_of_other_people(team)
    other_team_member_count = team.team_participants.count - 1

    "#{other_team_member_count} other #{other_team_member_count == 1 ? 'person' : 'people'}"
  end

  def invitation_team_link(team)
    if team.persisted?
      link_to team.name, challenge_team_url(team.challenge, team), target: '_blank'
    else
      "“#{team.name}”"
    end
  end
end
