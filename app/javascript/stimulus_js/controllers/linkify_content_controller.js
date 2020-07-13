import { Controller } from "stimulus"
import linkifyHtml from 'linkifyjs/html';

export default class extends Controller {
  connect() {
    const element = $(this.element)

    element.html(linkifyHtml(element.html()))
  }
}
