import { Controller } from 'stimulus'

export default class extends Controller {
  connect() {
    const currentUrl     = new URL(window.location);
    const referredByUUID = currentUrl.searchParams.get('referred_by_uuid');

    if (referredByUUID) {
      localStorage.setItem("referredByUUID", referredByUUID);
    }
  }
}
