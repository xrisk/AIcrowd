class ActiveAdminParticipantAuthorization < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    if subject.name == "Participant" || subject.class.to_s == "Participant"
      if user.super_admin?
        return true
      else
        return false
      end
    else
      return true
    end
  end
end