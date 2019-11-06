module ChallengesHelper

  def participant_invitation(email:)
    participant = Participant.find_by(email: email)
    if participant.is_a?(NullParticipant)
      return 'No AIcrowd account'
    else
      return link_to participant.name, participant_path(participant)
    end
  end

  def status_dropdown_helper(builder:)
    challenge = builder.object
    statuses = Challenge.statuses.hash
    if challenge.challenge_rounds.none? || challenge.dataset_files.none?
      statuses = statuses.except(:running,:completed,:terminated)
    end
    return builder.select(:status, statuses.map {|k,v| [v.humanize,k]}, {}, {class: "form-control", required: true}) 
  end

  def needs_to_agree_to_terms_or_rules?(challenge)
    if !policy(challenge).has_accepted_participation_terms?
      return true
    elsif !policy(challenge).has_accepted_challenge_rules?
      return true
    end
    return false
  end

  def required_terms_or_rules_path(challenge)
    if !policy(challenge).has_accepted_participation_terms?
      return url_for([challenge, ParticipationTerms.current_terms])
    elsif !policy(challenge).has_accepted_challenge_rules?
      return url_for([challenge, challenge.current_challenge_rules])
    end
    return nil
  end

end
