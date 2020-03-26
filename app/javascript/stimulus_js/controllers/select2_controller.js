import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    const requestUrl = this.data.get('url')

    $(this.element).select2({
      ajax: {
        delay:    100,
        url:      requestUrl,
        dataType: 'json'
      }
    })
  }
}
