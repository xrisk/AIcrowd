import { Controller } from "stimulus"

export default class extends Controller {

  readNotifications(){
    const participant_id   = this.data.get('participant-id');
    const notification_ids = this.data.get('notification-id');

    $.ajax({
      url: "/participants/"+ participant_id + "/read_notification/" + notification_ids + ".js",
      data: { participant_id: participant_id, ids: notification_ids }
    });
  }
}
