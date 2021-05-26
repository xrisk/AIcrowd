class ActiveAdminParticipantAuthorization < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    if subject.name == "Participant"
      if ENV["PERMITTED_IDS"].split(',').map(&:to_i).include?(user.id)
        return true
      else
        return false
      end
    else
      return true
    end
  end
end