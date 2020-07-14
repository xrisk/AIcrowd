import { Controller } from 'stimulus'

export default class extends Controller {
  connect() {
    const referredByUUID = localStorage.getItem('referredByUUID')

    if (referredByUUID) {
      const referredByUUIDField = document.getElementById('referred_by_uuid');

      referredByUUIDField.value = referredByUUID;
    }
  }
}
