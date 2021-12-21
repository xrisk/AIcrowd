import { Controller } from "stimulus"

export default class extends Controller {

  interactedPopup(){
    const endDate = this.data.get('end-date')

    document.cookie =
            "_cookie_weekly_challenge=" + endDate + "; expires=Fri, 31 Dec 9999 23:58:59 GMT; path=/";
  }
}