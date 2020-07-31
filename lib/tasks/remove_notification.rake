namespace :remove_notification do
  desc "Delete notification thats leaderboard don't have show_leaderbaord permission"
  task leaderbaord_is_not_for_show: :environment do
    notifications = Notification.where(notifiable_type: 'Leaderboard')

    notifications.each do |notification|
      next if notification.notifiable&.show_leaderboard?

      puts "Deleting notification #{notification.id} of Leaderboard #{notification.notifiable&.id}"
      notification.delete
    end
  end
end
