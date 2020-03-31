import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    const requestUrl = this.data.get('url')
    const placeholder = this.data.get('placeholder')

    $(this.element).select2({
      placeholder: placeholder,
      ajax: {
        delay:    100,
        url:      requestUrl,
        dataType: 'json'
      }
    })
  }
}
