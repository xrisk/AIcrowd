class AddChallengeToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :challenge, foreign_key: true
  end
end
