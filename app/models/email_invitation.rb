class EmailInvitation < ApplicationRecord
  after_initialize :init_token, if: :new_record?

  has_one :invitee_team_invitation, class_name: 'TeamInvitation', inverse_of: :invitee_email_invitation

  def init_token
    self.token ||= Base31.secure_random_str(9)
  end

  def display_token
    Base31.display_token(token, 3, '-')
  end
end
