import { Controller } from 'stimulus'

export default class extends Controller {
  connect() {
    const referredByUUID = localStorage.getItem('referredByUUID')

    if (referredByUUID) {
      const referredByUUIDField = document.getElementById('referred_by_uuid');

      referredByUUIDField.value = referredByUUID;
    }

    $(".toggle-password").click(function() {
      $(this).toggleClass("fa-eye fa-eye-slash");
      var input = $($(this).attr("toggle"));
      if (input.attr("type") == "password") {
        input.attr("type", "text");
      } else {
        input.attr("type", "password");
      }
    });
  }
}
