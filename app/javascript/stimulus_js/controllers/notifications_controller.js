import { Controller } from "stimulus"

export default class extends Controller {

  readNotifications(){
    const participant_id   = this.data.get('participant-id');
    const notification_ids = this.data.get('notification-id');

    if($('.dropdown-menu-notifications').hasClass('show'))
    {
      return false;
    }

    $(document).click(function(){
      $('.dropdown-menu-notifications').removeClass('show');
      $(".dropdown-menu-notifications").hide();
    });

    $.ajax({
      url: "/participants/"+ participant_id + "/read_notification/" + notification_ids + ".js",
      data: {is_js_request: true}
    });
  }
}
